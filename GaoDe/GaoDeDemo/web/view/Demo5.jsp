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
    <title>地理围栏</title>
    <link rel="stylesheet" type="text/css" href="../plugins/bootstrap/css/bootstrap.css"/>
    <link rel="stylesheet" type="text/css" href="../css/Demo5.css"/>
</head>
<>
<div class="content col-md-6 col-md-offset-3 content col-sm-8 col-sm-offset-2" style="margin-top: 5%;">
    <div class="panel panel-info">
        <div class="panel-heading">
            <h3 class="panel-title">创建围栏</h3>
        </div>
        <div class="panel-body">
            <div>中心点：</div>
            <input type="text" class="form-control" id="center" placeholder="请输入围栏中心结构化地址信息">
        </div>
        <div class="panel-body">
            <div>半径（米）[0,5000]：</div>
            <input type="number" class="form-control" id="radius" placeholder="请输入围栏半径">
        </div>
    </div>
    <div class="myFlex">
        <div class="ps">PS：结构化地址信息格式为省份＋城市＋区县＋城镇＋乡村＋街道＋门牌号码</div>
        <button onclick="setArea()" class="btn btn-default">新建</button>
    </div>
    <hr>
    <img src="../img/qiandao.png" onclick="sign()" class="img1"/>
    <hr>
    <div class="myFlex2"><button onclick="deleteArea()" class="btn btn-danger">删除围栏</button></div>
    <hr>
</div>

<!-- 模态框（Modal） -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">打卡成功</h4>
            </div>
            <div class="modal-body">慢慢地你就会明白，现在我们付出的每一滴汗水，其实都并没有什么用。</div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal">确定</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>
<!-- 模态框（Modal） -->
<div class="modal fade" id="myModal2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel2">打卡失败</h4>
            </div>
            <div class="modal-body">您还未进入可打卡区域，请再回去睡一会吧。</div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal">确定</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>

</body>
<!--引入jquery-->
<script type="text/javascript" src="../plugins/jquery/jquery.min.js"></script>
<!--引入bootstrap.js-->
<script type="text/javascript" src="../plugins/bootstrap/js/bootstrap.js"></script>
<script type="text/javascript">
    var gid="";
    function setArea() {
        var input_adress = document.getElementById("center").value;
        var xmlHttp;
        xmlHttp = new XMLHttpRequest();
        xmlHttp.onreadystatechange = function ()//异步请求，在没有得到服务器响应之前，代码继续向下运行
        {
            if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
                //解析json并将解析出的值传入html
                var obj = eval('(' + xmlHttp.responseText + ')');
                var temp = obj.geocodes;
                var obj2 = temp[0];
                var center = obj2.location;
                var radius =document.getElementById("radius").value;
                $.ajax({
                    url: "https://restapi.amap.com/v4/geofence/meta?key=da89dbb834cdbffe52dc14f8d62392af",
                    type: "post",
                    dataType: "json",
                    data: JSON.stringify({"name":"围栏Demo","center":center,"radius":radius,"repeat":"Mon,Tues,Wed,Thur,Fri,Sat,Sun"}),
                    contentType:"json/application",
                    success: function (res) {
                        console.log(res.data);
                        var obj = eval('(' + JSON.stringify(res.data) + ')');
                        gid=obj.gid;
                        alert("围栏创建成功！");
                    }
                })
            }
        }
        xmlHttp.open("GET", "https://restapi.amap.com/v3/geocode/geo?address=" + input_adress + "&key=da89dbb834cdbffe52dc14f8d62392af", true);
        xmlHttp.send();  //发送请求

    }
    function sign() {
        var xmlHttp;
        xmlHttp = new XMLHttpRequest();
        xmlHttp.onreadystatechange = function ()
        {
            if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
                console.log(xmlHttp.responseText);
                var obj = eval('(' + xmlHttp.responseText + ')');
                var temp =obj.data.fencing_event_list;
                if(temp.length==0)
                    $('#myModal2').modal('show');
                else
                    $('#myModal').modal('show');
            }
        }
        xmlHttp.open("GET", "https://restapi.amap.com/v4/geofence/status?key=da89dbb834cdbffe52dc14f8d62392af&diu=868144031116194&locations=120.729000,31.262500,1554816232", true);
        xmlHttp.send();  //发送请求
    }
    function deleteArea() {
        var xmlHttp;
        xmlHttp = new XMLHttpRequest();
        xmlHttp.onreadystatechange = function ()//异步请求，在没有得到服务器响应之前，代码继续向下运行
        {
            if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
                console.log(xmlHttp.responseText);
                alert("围栏删除成功！");
            }
        }
        xmlHttp.open("DELETE", "https://restapi.amap.com/v4/geofence/meta?key=da89dbb834cdbffe52dc14f8d62392af&gid="+gid, true);
        xmlHttp.send();  //发送请求
    }
</script>
</html>
