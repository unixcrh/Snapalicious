Parse.Cloud.beforeSave("Post", function(request, response) {
  var momentThumb = request.object.get("momentThumb");
  request.object.set("momentThumbOnS3", momentThumb.url);

  var t = request.object.get("title");

  Parse.Cloud.run('addTags', { title: t }, {
    success: function(tags) {
      request.object.set("tags", tags);
    },
    error: function(error) {

    }
  });

  response.success();
});