Parse.Cloud.afterSave("RecipeRequest", function(request) {
  query = new Parse.Query("RecipeRequest");
  query.include('fromUser');
  query.include('toUser');
  query.include('post')
  query.get(request.object.id, {
    success: function(request) {
      var fromUser = request.get('fromUser');
      var toUser = request.get('toUser');
      var post = request.get('post');
      var title = post.get('title');

      var query = new Parse.Query(Parse.Installation);
      query.equalTo('owner', toUser);
      Parse.Push.send({
        where: query, // Set our Installation query
        data: {
          alert: fromUser.get('profileName') + ' would like to learn more for ' + title
        }
      }, {
        success: function() {
          // Push was successful
        },
        error: function(error) {
          // Handle error
        }
      });
    },
    error: function(error) {
      throw "Got an error " + error.code + " : " + error.message;
    }
  });
});