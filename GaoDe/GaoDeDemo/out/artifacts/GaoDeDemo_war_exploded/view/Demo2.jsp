<%--
  Created by IntelliJ IDEA.
  User: TXT
  Date: 2019/7/20
  Time: 16:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>静态地图</title>
    <link rel="stylesheet" type="text/css" href="../plugins/bootstrap/css/bootstrap.css"/>
    <link rel="stylesheet" type="text/css" href="../css/Demo2.css"/>
</head>
<body>
<div class="content col-md-6 col-md-offset-3 content col-sm-8 col-sm-offset-2" style="margin-top: 5%;">
    <div class="panel panel-info">
        <div class="panel-heading">
            <h3 class="panel-title">静态地图</h3>
        </div>
        <div class="panel-body">
            <div>Adress：</div>
            <input type="text" class="form-control" id="input_adress" placeholder="请输入结构化地址信息">
        </div>
        <div class="panel-body">
            <div>地图缩放级别[1,17]：</div>
            <input type="number" class="form-control" id="input_level" placeholder="请输入1-17之间的数字">
        </div>
        <div class="panel-body">
            <div>图片类型：</div>
            <div class="radio-inline">
                <label class="radio">
                    <input type="radio" name="img_type" value="1"/>普通
                </label>
                <label class="radio">
                    <input type="radio" name="img_type" value="2"/>高清
                </label>
            </div>
        </div>
        <div class="panel-body">
            <div>实时路况：</div>
            <div class="radio-inline">
                <label class="radio">
                    <input type="radio" name="is_show" value="0"/>不展现
                </label>
                <label class="radio">
                    <input type="radio" name="is_show" value="1"/>展现
                </label>
            </div>
        </div>
    </div>
    <div class="myFlex">
        <div class="ps">PS：结构化地址信息格式为省份＋城市＋区县＋城镇＋乡村＋街道＋门牌号码</div>
        <button onclick="getMap()" class="btn btn-default">运行</button>
    </div>
    <hr>
    <image id="image" src="../img/mlxg.png" width="100%"></image>
    <hr>
</div>
</body>
<!--引入jquery-->
<script type="text/javascript" src="../plugins/jquery/jquery.min.js"></script>
<!--引入bootstrap.js-->
<script type="text/javascript" src="../plugins/bootstrap/js/bootstrap.js"></script>
<script type="text/javascript">
    function getMap() {
        var input_adress = document.getElementById("input_adress").value;
        var xmlHttp;
        xmlHttp = new XMLHttpRequest();
        xmlHttp.onreadystatechange = function () {
            if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
                var obj = eval('(' + xmlHttp.responseText + ')');
                var temp = obj.geocodes;
                var obj2 = temp[0];
                var location = obj2.location;
                var level = document.getElementById("input_level").value;
                var scale = "";
                var traffic = "";
                var temp_radio = document.getElementsByName("img_type");
                for (var i = 0; i < temp_radio.length; i++) {
                    if (temp_radio[i].checked) {
                        scale = temp_radio[i].value;
                        break;
                    }
                }
                var temp_radio2 = document.getElementsByName("is_show");
                for (var i = 0; i < temp_radio2.length; i++) {
                    if (temp_radio2[i].checked) {
                        traffic = temp_radio2[i].value;
                        break;
                    }
                }
                var src = "https://restapi.amap.com/v3/staticmap?location=" + location + "&zoom=" + level + "&size=400*400&markers=large,,:" + location + "&key=da89dbb834cdbffe52dc14f8d62392af&traffic=" + traffic + "&scale=" + scale;
                document.getElementById('image').src = src;
            }
        }
        xmlHttp.open("GET", "https://restapi.amap.com/v3/geocode/geo?address=" + input_adress + "&key=da89dbb834cdbffe52dc14f8d62392af", true);
        xmlHttp.send();
    }
</script>
</html>
