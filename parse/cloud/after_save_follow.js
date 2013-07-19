Parse.Cloud.afterSave("Follows", function(request) {
  query = new Parse.Query("Follows");
  query.include('fromUser');
  query.include('toUser');
  query.get(request.object.id, {
    success: function(follow) {
      var flag = follow.get('flag');
      if (flag == true) {
        var fromUser = follow.get('fromUser');
        var toUser = follow.get('toUser');

        var query = new Parse.Query(Parse.Installation);
        query.equalTo('owner', toUser);
        Parse.Push.send({
          where: query, // Set our Installation query
          data: {
            alert: 'You have a new follower on Snapalicious'
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