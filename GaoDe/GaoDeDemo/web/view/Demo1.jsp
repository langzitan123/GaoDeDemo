<%--
  Created by IntelliJ IDEA.
  User: TXT
  Date: 2019/7/20
  Time: 16:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>地理编码</title>
    <link rel="stylesheet" type="text/css" href="../plugins/bootstrap/css/bootstrap.css"/>
    <link rel="stylesheet" type="text/css" href="../css/Demo1.css"/>
</head>
<body>
<div class="content col-md-6 col-md-offset-3 content col-sm-8 col-sm-offset-2" style="margin-top: 5%;">
    <div class="panel panel-info">
        <div class="panel-heading">
            <h3 class="panel-title">地理编码</h3>
        </div>
        <div class="panel-body">
            <div>Adress：</div>
            <input type="text" class="form-control" id="input_adress" placeholder="请输入结构化地址信息">
        </div>
    </div>
    <div class="myFlex">
        <div class="ps">PS：结构化地址信息格式为省份＋城市＋区县＋城镇＋乡村＋街道＋门牌号码</div>
        <button onclick="getInfo()" class="btn btn-default">运行</button>
    </div>
    <hr>
    <div class="result">当前结构化地址信息所在的经纬度坐标点为(
        <span id="myLocation">0,0</span>
        )
    </div>
</div>
</body>
<!--引入jquery-->
<script type="text/javascript" src="../plugins/jquery/jquery.min.js"></script>
<!--引入bootstrap.js-->
<script type="text/javascript" src="../plugins/bootstrap/js/bootstrap.js"></script>
<script type="text/javascript">
    function getInfo() {
        var input_adress = document.getElementById("input_adress").value;
        var xmlHttp;
        xmlHttp = new XMLHttpRequest();
        xmlHttp.onreadystatechange = function ()//异步请求，在没有得到服务器响应之前，代码继续向下运行
        {
            if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
                //解析json并将解析出的值传入html
                var obj = eval('(' + xmlHttp.responseText + ')');
                var temp = obj.geocodes;
                var obj2 = temp[0];
                var location = obj2.location;
                document.getElementById("myLocation").innerHTML = location;
            }
        }
        xmlHttp.open("GET", "https://restapi.amap.com/v3/geocode/geo?address=" + input_adress + "&key=da89dbb834cdbffe52dc14f8d62392af", true);
        xmlHttp.send();  //发送请求
    }
</script>
</html>
