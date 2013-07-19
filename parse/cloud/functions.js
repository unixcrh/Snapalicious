Parse.Cloud.define("addTags", function(request, response) {
  // Generates tags
  var s = request.params.title;
  var array = s.split(' ');
  var tags = [];
  for (var i=0; i<array.length;i++) {
    var aTag = array[i];
    if (aTag.length > 3) {
      tags.push(aTag);
    }
  }
  response.success(tags);
});