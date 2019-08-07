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
    <title>IP定位</title>
    <link rel="stylesheet" type="text/css" href="../plugins/bootstrap/css/bootstrap.css"/>
    <link rel="stylesheet" type="text/css" href="../css/Demo4.css"/>
</head>
<body>
<div class="content col-md-6 col-md-offset-3 content col-sm-8 col-sm-offset-2" style="margin-top: 5%;">
    <div class="panel panel-info">
        <div class="panel-heading">
            <h3 class="panel-title">IP定位</h3>
        </div>
        <div class="panel-body">
            <div>IP地址：</div>
            <input type="text" class="form-control" id="input_ip" placeholder="请输入需要搜索的ip地址">
        </div>
    </div>
    <div class="myFlex">
        <div class="ps">PS：若输入为空，则定位http请求发送的位置</div>
        <button onclick="getInfo()" class="btn btn-default">运行</button>
    </div>
    <hr>
    <div class="result">IP地址对应的城市为：<span id="myLocation" class="result2"></span></div>
</div>
</body>
<!--引入jquery-->
<script type="text/javascript" src="../plugins/jquery/jquery.min.js"></script>
<!--引入bootstrap.js-->
<script type="text/javascript" src="../plugins/bootstrap/js/bootstrap.js"></script>
<script type="text/javascript">
    function getInfo() {
        var input_ip = document.getElementById("input_ip").value;
        var xmlHttp;
        xmlHttp = new XMLHttpRequest();
        xmlHttp.onreadystatechange = function ()//异步请求，在没有得到服务器响应之前，代码继续向下运行
        {
            if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
                //解析json并将解析出的值传入html
                var obj = eval('(' + xmlHttp.responseText + ')');
                var location = obj.province+obj.city;
                if(obj.province==obj.city)//直辖市或局域网
                    location =obj.city;
                document.getElementById("myLocation").innerHTML = location;
            }
        }
        if (input_ip=="")//若输入为空，则定位http请求发送的位置
            xmlHttp.open("GET", "https://restapi.amap.com/v3/ip?key=da89dbb834cdbffe52dc14f8d62392af", true);
        else
            xmlHttp.open("GET", "https://restapi.amap.com/v3/ip?key=da89dbb834cdbffe52dc14f8d62392af&ip="+input_ip, true);
        xmlHttp.send();  //发送请求
    }
</script>
</html>
