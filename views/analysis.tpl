<!DOCTYPE html>
<html>
<head>
    <title>XHR</title>
    <meta charset="utf-8">
    <style type="text/css">
        .container{width: 500px;
          padding: 20px 0px 40px 30px;
          border:1px solid #000;
          border-radius: 10px;
          margin:0 auto;
          -moz-box-shadow:1px 5px 7px #f1f1f1; -webkit-box-shadow:1px 5px 7px #f1f1f1; box-shadow:1px 5px 7px #f1f1f1;
          background:-ms-linear-gradient(top, #fff,  #f2f2f2;);        /* IE 10 */
          background:-moz-linear-gradient(top,#fff,#f2f2f2);/*火狐*/ 
          background:-webkit-gradient(linear, 0% 0%, 0% 100%,from(#fff), to(#f2f2f2));/*谷歌*/ 
          background:-webkit-gradient(linear, 0% 0%, 0% 100%, from(#fff), to(#f2f2f2));      /* Safari 4-5, Chrome 1-9*/
          background:-webkit-linear-gradient(top, #fff, #f2f2f2);   /*Safari5.1 Chrome 10+*/
          background:-o-linear-gradient(top, #fff, #f2f2f2);  /*Opera 11.10+*/;
          font-family: \5FAE\8F6F\96C5\9ED1;
        }
        .row{margin-top: 20px;margin-bottom: 20px;}
        .choose{width: 370px;border: 1px solid #cccccc;height: 30px;border-radius: 10px;margin-top: 20px;padding-left: 30px;padding-top: 10px;font-family: \5FAE\8F6F\96C5\9ED1;}
        .btn{height: 30px;line-height: 30px;width: 100px;text-align: center;font-family: \5FAE\8F6F\96C5\9ED1;}
        .prompt{color: #b8b5b0;font-style: oblique;}
        .massage{font-size: 16px;font-family: \5FAE\8F6F\96C5\9ED1;margin-top: 10px;margin-bottom: 10px;}
    </style>
</head>
<body>
<div class="container">
  <form id="form1" enctype="multipart/form-data" method="post" action="/upload">
    <div class="row">
      <label for="fileToUpload">Please choose video file</label><br />
      <input type="file" name="fileToUpload" id="fileToUpload" onchange="fileSelected();" class="choose" />
    </div>
    <div id="fileName" class="prompt"></div>
    <div id="fileSize" class="prompt"></div>
    <div id="fileType" class="prompt"></div>
    <div class="row ">
      <input type="button" onclick="uploadFile()" value="Upload"  class="btn" />
      <p id="url-massage" class="massage"></p>
    </div>
    <div id="progressNumber"></div>
  </form>
</div>
  <script type="text/javascript">
    function fileSelected() {
      var file = document.getElementById('fileToUpload').files[0];
      if (file) {
        var fileSize = '0KB';
        if (file.size > 1024 * 1024){
          fileSize = (Math.round(file.size * 100 / (1024 * 1024)) / 100).toString() + 'MB';
        }
        else{
          fileSize = (Math.round(file.size * 100 / 1024) / 100).toString() + 'KB';
        }

        document.getElementById('fileName').innerHTML = 'Name: ' + file.name;
        document.getElementById('fileSize').innerHTML = 'Size: ' + fileSize;
        document.getElementById('fileType').innerHTML = 'Type: ' + file.type;
      }
    }

    function uploadFile() {
      var fd = new FormData();
      fd.append("fileToUpload", document.getElementById('fileToUpload').files[0]);
      fd.append("filePath", "android_board_id/date/task_id");
      var xhr = new XMLHttpRequest();
      xhr.upload.addEventListener("progress", uploadProgress, false);
      xhr.addEventListener("load", uploadComplete, false);
      xhr.addEventListener("error", uploadFailed, false);
      xhr.addEventListener("abort", uploadCanceled, false);
      xhr.open("POST", "/analysis");
      xhr.send(fd);
    }

    function uploadProgress(evt) {
      if (evt.lengthComputable) {
        var percentComplete = Math.round(evt.loaded * 100 / evt.total);
        document.getElementById('progressNumber').innerHTML = percentComplete.toString() + '%';
      }
      else {
        document.getElementById('progressNumber').innerHTML = 'unable to compute';
      }
    }

    var urlMassage = document.getElementById("url-massage");

    function uploadComplete(evt) {
      /* This event is raised when the server send back a response */
      //alert(evt.target.responseText);
      urlMassage.innerHTML = evt.target.responseText;
    }

    function uploadFailed(evt) {
      alert("There was an error attempting to upload the file.");
    }

    function uploadCanceled(evt) {
      alert("The upload has been canceled by the user or the browser dropped the connection.");
    }
  </script>
</body>
</html>
