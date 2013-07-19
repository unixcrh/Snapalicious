// Require the SendGrid Cloud Module
var sendgrid = require("sendgrid");
sendgrid.initialize("SENDGRID_USERNAME", "SENDGRID_PASSWORD");

Parse.Cloud.afterSave("Post", function(request) {
  query = new Parse.Query("Post");
  query.include("author");
  query.get(request.object.id, {
    success: function(post) {

      var title = post.get('title');
      var author = post.get("author");

      var query = new Parse.Query(Parse.User);
      query.descending("createdAt");
      query.exists("profileName");
      query.find({
        success: function(results) {
          console.log(results);
          for (var i = 0; i < results.length; i++) {
            var aUser = results[i];
            var profileName = aUser.get('profileName');            
            var query2 = new Parse.Query(Parse.Installation);
            query2.equalTo('owner', aUser);
            
            Parse.Push.send({
              where: query2, // Set our Installation query
              data: {
                alert: "There is a new dish! " + title
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
          alert("Error: " + error.code + " " + error.message);
        }
      });

      sendgrid.sendEmail({
        to: "TO_EMAIL",
        from: "FROM_EMAIL",
        subject: title + " on Snapalicious!",
        text: "There is a new dish! " + title
      }, {
        success: function() {},
        error: function() {}
      });
    },
    error: function(error) {
      throw "Got an error " + error.code + " : " + error.message;
    }
  });
});