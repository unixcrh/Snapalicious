Parse.Cloud.define("resetScore", function(request, response) {
  Parse.Cloud.useMasterKey();

  var query = new Parse.Query(Parse.User);
  query.get(request.params.user, {
    success: function(user) {
      user.set("score", 0);
      user.save();

      response.success("Done!");
    },
    error: function(error) {
      throw "Got an error " + error.code + " : " + error.message;
    }
  });
});

Parse.Cloud.define("userPost", function(request, response) {
  Parse.Cloud.useMasterKey();

  var query = new Parse.Query("Post");
  query.include("author");
  query.get(request.params.post, {
    success: function(post) {
      var user = post.get("author");
      var relation = user.relation("posts");
      relation.add(post);
      user.save();

      response.success("Done!");
    },
    error: function(error) {
      throw "Got an error " + error.code + " : " + error.message;
    }
  });
});

Parse.Cloud.define("userLike", function(request, response) {
  Parse.Cloud.useMasterKey();

  var query = new Parse.Query("Snapalicious");
  query.include("fromUser");
  query.get(request.params.like, {
    success: function(like) {
      var user = like.get("fromUser");
      var relation = user.relation("likes");
      relation.add(like);
      user.save();

      response.success("Done!");
    },
    error: function(error) {
      throw "Got an error " + error.code + " : " + error.message;
    }
  });
});

Parse.Cloud.define("userRecipe", function(request, response) {
  Parse.Cloud.useMasterKey();

  var query = new Parse.Query("Recipe");
  query.include("fromUser");
  query.get(request.params.recipe, {
    success: function(recipe) {
      var user = recipe.get("fromUser");
      var relation = user.relation("recipes");
      relation.add(recipe);
      user.save();

      response.success("Done!");
    },
    error: function(error) {
      throw "Got an error " + error.code + " : " + error.message;
    }
  });
});