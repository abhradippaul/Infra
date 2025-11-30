import {
  GetObjectCommand,
  PutObjectCommand,
  S3Client,
} from "@aws-sdk/client-s3";
import Sharp from "sharp";

const s3Client = new S3Client({
  region: "ap-south-1",
});
const S3_ORIGINAL_IMAGE_BUCKET = process.env.originalImageBucketName;
const S3_TRANSFORMED_IMAGE_BUCKET = process.env.transformedImageBucketName;
const TRANSFORMED_IMAGE_CACHE_TTL = process.env.transformedImageCacheTTL;
const MAX_IMAGE_SIZE = parseInt(process.env.maxImageSize);

export const handler = async (event) => {
  if (
    !event.requestContext ||
    !event.requestContext.http ||
    !(event.requestContext.http.method === "GET")
  )
    return sendError(400, "Only GET method is supported", event);
  var imagePathArray = event.requestContext.http.path.split("/");
  var operationsPrefix = imagePathArray.pop();
  imagePathArray.shift();
  var originalImagePath = imagePathArray.join("/");

  var startTime = performance.now();
  let originalImageBody;
  let contentType;
  console.log(S3_ORIGINAL_IMAGE_BUCKET, originalImagePath);
  try {
    const getOriginalImageCommand = new GetObjectCommand({
      Bucket: S3_ORIGINAL_IMAGE_BUCKET,
      Key: originalImagePath,
    });
    const getOriginalImageCommandOutput = await s3Client.send(
      getOriginalImageCommand
    );
    console.log(`Got response from S3 for ${originalImagePath}`);

    originalImageBody =
      getOriginalImageCommandOutput.Body.transformToByteArray();
    contentType = getOriginalImageCommandOutput.ContentType;
  } catch (error) {
    if (error.name === "NoSuchKey") {
      return sendError(404, "The requested image does not exist", error);
    }
    return sendError(500, "Error downloading original image", error);
  }
  let transformedImage = Sharp(await originalImageBody, {
    failOn: "none",
    animated: true,
  });
  const imageMetadata = await transformedImage.metadata();
  const operationsJSON = Object.fromEntries(
    operationsPrefix.split(",").map((operation) => operation.split("="))
  );
  var timingLog = "img-download;dur=" + parseInt(performance.now() - startTime);
  startTime = performance.now();
  try {
    var resizingOptions = {};
    if (operationsJSON["width"])
      resizingOptions.width = parseInt(operationsJSON["width"]);
    if (operationsJSON["height"])
      resizingOptions.height = parseInt(operationsJSON["height"]);
    if (resizingOptions)
      transformedImage = transformedImage.resize(resizingOptions);
    if (imageMetadata.orientation) transformedImage = transformedImage.rotate();
    if (operationsJSON["format"]) {
      var isLossy = false;
      switch (operationsJSON["format"]) {
        case "jpeg":
          contentType = "image/jpeg";
          isLossy = true;
          break;
        case "gif":
          contentType = "image/gif";
          break;
        case "webp":
          contentType = "image/webp";
          isLossy = true;
          break;
        case "png":
          contentType = "image/png";
          break;
        case "avif":
          contentType = "image/avif";
          isLossy = true;
          break;
        default:
          contentType = "image/jpeg";
          isLossy = true;
      }
      if (operationsJSON["quality"] && isLossy) {
        transformedImage = transformedImage.toFormat(operationsJSON["format"], {
          quality: parseInt(operationsJSON["quality"]),
        });
      } else
        transformedImage = transformedImage.toFormat(operationsJSON["format"]);
    } else {
      if (contentType === "image/svg+xml") contentType = "image/png";
    }
    transformedImage = await transformedImage.toBuffer();
  } catch (error) {
    return sendError(500, "error transforming image", error);
  }
  timingLog =
    timingLog + ",img-transform;dur=" + parseInt(performance.now() - startTime);

  const imageTooBig = Buffer.byteLength(transformedImage) > MAX_IMAGE_SIZE;

  if (S3_TRANSFORMED_IMAGE_BUCKET) {
    startTime = performance.now();
    try {
      const putImageCommand = new PutObjectCommand({
        Body: transformedImage,
        Bucket: S3_TRANSFORMED_IMAGE_BUCKET,
        Key: originalImagePath + "/" + operationsPrefix,
        ContentType: contentType,
        CacheControl: TRANSFORMED_IMAGE_CACHE_TTL,
      });
      await s3Client.send(putImageCommand);
      timingLog =
        timingLog +
        ",img-upload;dur=" +
        parseInt(performance.now() - startTime);
      if (imageTooBig) {
        return {
          statusCode: 302,
          headers: {
            Location:
              "/" +
              originalImagePath +
              "?" +
              operationsPrefix.replace(/,/g, "&"),
            "Cache-Control": "private,no-store",
            "Server-Timing": timingLog,
          },
        };
      }
    } catch (error) {
      logError("Could not upload transformed image to S3", error);
    }
  }

  if (imageTooBig) {
    return sendError(403, "Requested transformed image is too big", "");
  } else
    return {
      statusCode: 200,
      body: transformedImage.toString("base64"),
      isBase64Encoded: true,
      headers: {
        "Content-Type": contentType,
        "Cache-Control": TRANSFORMED_IMAGE_CACHE_TTL,
        "Server-Timing": timingLog,
      },
    };
};

function sendError(statusCode, body, error) {
  logError(body, error);
  return { statusCode, body };
}

function logError(body, error) {
  console.log("APPLICATION ERROR", body);
  console.log(error);
}
