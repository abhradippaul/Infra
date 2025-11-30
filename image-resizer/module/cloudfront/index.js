function handler(event) {
  var request = event.request;
  var originalImagePath = request.uri;
  var normalizedOperations = {};
  if (request.querystring) {
    Object.keys(request.querystring).forEach((operation) => {
      switch (operation.toLowerCase()) {
        case "format":
          var SUPPORTED_FORMATS = [
            "auto",
            "jpeg",
            "webp",
            "avif",
            "png",
            "svg",
            "gif",
          ];
          if (
            request.querystring[operation]["value"] &&
            SUPPORTED_FORMATS.includes(
              request.querystring[operation]["value"].toLowerCase()
            )
          ) {
            var format = request.querystring[operation]["value"].toLowerCase();
            if (format === "auto") {
              format = "jpeg";
              if (request.headers["accept"]) {
                if (request.headers["accept"].value.includes("avif")) {
                  format = "avif";
                } else if (request.headers["accept"].value.includes("webp")) {
                  format = "webp";
                }
              }
            }
            normalizedOperations["format"] = format;
          }
          break;
        case "width":
          if (request.querystring[operation]["value"]) {
            var width = parseInt(request.querystring[operation]["value"]);
            if (!isNaN(width) && width > 0) {
              normalizedOperations["width"] = width.toString();
            }
          }
          break;
        case "height":
          if (request.querystring[operation]["value"]) {
            var height = parseInt(request.querystring[operation]["value"]);
            if (!isNaN(height) && height > 0) {
              normalizedOperations["height"] = height.toString();
            }
          }
          break;
        case "quality":
          if (request.querystring[operation]["value"]) {
            var quality = parseInt(request.querystring[operation]["value"]);
            if (!isNaN(quality) && quality > 0) {
              if (quality > 100) quality = 100;
              normalizedOperations["quality"] = quality.toString();
            }
          }
          break;
        default:
          break;
      }
    });
    if (Object.keys(normalizedOperations).length > 0) {
      var normalizedOperationsArray = [];
      if (normalizedOperations.format)
        normalizedOperationsArray.push("format=" + normalizedOperations.format);
      if (normalizedOperations.quality)
        normalizedOperationsArray.push(
          "quality=" + normalizedOperations.quality
        );
      if (normalizedOperations.width)
        normalizedOperationsArray.push("width=" + normalizedOperations.width);
      if (normalizedOperations.height)
        normalizedOperationsArray.push("height=" + normalizedOperations.height);
      request.uri =
        originalImagePath + "/" + normalizedOperationsArray.join(",");
    } else {
      request.uri = originalImagePath + "/original";
    }
  } else {
    request.uri = originalImagePath + "/original";
  }
  request["querystring"] = {};
  return request;
}
