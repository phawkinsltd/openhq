$(function() {
  $(document).on("click", ".attach-files", function(ev) {
    ev.preventDefault();

    $("#s3-file-upload-field").click();
  });
});

App.onPageLoad(function() {

  $('#s3-uploader').S3Uploader({
    allow_multiple_files: true,
    before_add: function(data){
      // TODO: validate upload?
      return true;
    },
    progress_bar_target: $('#attachments-list'),
    remove_completed_progress_bar: false
  });

  $("#s3-uploader").on("s3_uploads_start", function(e) {
    // An upload has started disable form
    var $target = $($(this).attr("data-target-form"));

    $target.find('input[type="submit"]').prop("disabled", true);
  });

  $("#s3-uploader").on("s3_uploads_complete", function(e) {
    // All uploads complete re-enable form
    var $target = $($(this).attr("data-target-form"));

    $target.find('input[type="submit"]').prop("disabled", false);
  });

  // $("#s3-uploader").on("s3_upload_failed", function(e) {
    // An upload has failed
  // });

  $("#s3-uploader").on("s3_upload_complete", function(e, content) {
    var $progress_bar = $("#file-"+ content.unique_id);

    $progress_bar.addClass("processing");
    $progress_bar.find(".info-message").text("Processing");

    $.ajax({
      type: "POST",
      url: window.location.pathname + "/attachments",
      data: {
        "attachment": {
          "name": content.filename,
          "file_name": content.filename,
          "file_size": content.filesize,
          "content_type": content.filetype,
          "file_path": decodeURIComponent(content.filepath.split("/")[2].replace(/\+/g, "%20"))
        }
      },
      dataType: "json"
    }).done(function(data) {
      console.log("Attachment added", data.attachment);
      var input = $('#comment_attachment_ids');
      input.val(input.val() + data.attachment.id + ',');

      $progress_bar.removeClass("processing").addClass("completed");
      $progress_bar.find(".info-message").text("Attached");
    }).fail(function() {
      console.error("Error creating attachment", arguments);
    });
  });

});