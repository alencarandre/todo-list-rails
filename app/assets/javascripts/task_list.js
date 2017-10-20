var TaskList = (function() {
  var TaskList = {};

  TaskList.init = function() {
    $(document).on("click", ".new-task-list", function() {
      $(".new-task-list-form-container").hide();
      $(".new-task-list-form-container").removeClass("hidden");
      $(".new-task-list-form-container").fadeIn();
    });

    $(document).on("click", ".cancel-new-task-list", function() {
      $(".new-task-list-form-container").fadeOut();
    });

    $(document).on("click", ".todo-task-list .tasks ul li:not(.readonly)", function() {
      var task_uri = $(this).data("uri");
      $.ajax(task_uri, {
        type: "POST",
        dataType: "script"
      })
    })
  }

  return TaskList;
})();
