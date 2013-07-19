Parse.Cloud.afterSave("Snapalicious", function(request) {
  query = new Parse.Query("Snapalicious");
  query.include('fromUser');
  query.include('toUser');
  query.get(request.object.id, {
    success: function(like) {
      var flag = like.get('flag');
      if (flag == true) {
        var fromUser = like.get('fromUser');
        var toUser = like.get('toUser');
        var dishName = like.get('dishName');

        var query = new Parse.Query(Parse.Installation);
        query.equalTo('owner', toUser);
        Parse.Push.send({
          where: query, // Set our Installation query
          data: {
            alert: fromUser.get('profileName') + ' likes ' + dishName
          }
        }, {
          success: function() {
            // Push was successful
          },
          error: function(error) {
            // Handle error
          }
        });
      }
    },
    error: function(error) {
      throw "Got an error " + error.code + " : " + error.message;
    }
  });
});