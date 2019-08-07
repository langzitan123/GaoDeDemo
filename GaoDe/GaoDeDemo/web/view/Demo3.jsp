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
    <title>路径规划</title>
    <link rel="stylesheet" type="text/css" href="../plugins/bootstrap/css/bootstrap.css"/>
    <link rel="stylesheet" type="text/css" href="../css/Demo3.css"/>
</head>
<body>
<div class="content col-md-6 col-md-offset-3 content col-sm-8 col-sm-offset-2" style="margin-top: 5%;">
    <div class="panel panel-info">
        <div class="panel-heading">
            <h3 class="panel-title">路径规划</h3>
        </div>
        <div class="panel-body">
            <div>出发点：</div>
            <input type="text" class="form-control" id="start" placeholder="请输入结构化地址信息">
        </div>
        <div class="panel-body">
            <div>目的地：</div>
            <input type="text" class="form-control" id="end" placeholder="请输入结构化地址信息">
        </div>
        <div class="panel-body">
            <div>出行方式：</div>
            <div class="radio-inline">
                <label class="radio">
                    <input type="radio" name="travel_type" value="1" onclick="fun('1')"/>步行
                </label>
                <label class="radio">
                    <input type="radio" name="travel_type" value="2" onclick="fun('2')"/>公交
                </label>
                <label class="radio">
                    <input type="radio" name="travel_type" value="3" onclick="fun('3')"/>驾车
                </label>
            </div>
        </div>
        <div id="strategy2" hidden>
            <div class="panel-body">
                <div>公交策略选择：</div>
                <div class="radio-inline">
                    <label class="radio">
                        <input type="radio" name="bus" value="0"/>最快捷模式
                    </label>
                    <label class="radio">
                        <input type="radio" name="bus" value="1"/>最经济模式
                    </label>
                    <label class="radio">
                        <input type="radio" name="bus" value="2"/>最少换乘模式
                    </label>
                    <label class="radio">
                        <input type="radio" name="bus" value="3"/>最少步行模式
                    </label>
                </div>
            </div>
        </div>
        <div id="strategy3" hidden>
            <div class="panel-body">
                <div>驾车策略选择：</div>
                <div class="radio-inline">
                    <label class="radio">
                        <input type="radio" name="car" value="10"/>默认策略
                    </label>
                    <label class="radio">
                        <input type="radio" name="car" value="12"/>躲避拥堵
                    </label>
                    <label class="radio">
                        <input type="radio" name="car" value="14"/>避免收费
                    </label>
                    <label class="radio">
                        <input type="radio" name="car" value="19"/>高速优先
                    </label>
                </div>
            </div>
        </div>
    </div>
    <div class="myFlex">
        <div class="ps">PS：结构化地址信息格式为省份＋城市＋区县＋城镇＋乡村＋街道＋门牌号码</div>
        <button onclick="getPlan()" class="btn btn-default">运行</button>
    </div>
    <div class="result">推荐路线：
        <div id="result" class="result2"></div>
    </div>
    <hr>
</div>
</body>
<!--引入jquery-->
<script type="text/javascript" src="../plugins/jquery/jquery.min.js"></script>
<!--引入bootstrap.js-->
<script type="text/javascript" src="../plugins/bootstrap/js/bootstrap.js"></script>
<script type="text/javascript">
    function fun(index) {
        if (index == 1) {
            document.getElementById("strategy2").setAttribute("hidden", "hidden");
            document.getElementById("strategy3").setAttribute("hidden", "hidden");
            document.getElementById("result").innerHTML = "";
        }
        if (index == 2) {
            document.getElementById("strategy3").setAttribute("hidden", "hidden");
            document.getElementById("strategy2").removeAttribute("hidden");
            document.getElementById("result").innerHTML = "";
        }
        if (index == 3) {
            document.getElementById("strategy2").setAttribute("hidden", "hidden");
            document.getElementById("strategy3").removeAttribute("hidden");
            document.getElementById("result").innerHTML = "";
        }
    }
    function getPlan() {
        var start_adress = document.getElementById("start").value;
        var xmlHttp1;
        xmlHttp1 = new XMLHttpRequest();
        xmlHttp1.onreadystatechange = function () {
            if (xmlHttp1.readyState == 4 && xmlHttp1.status == 200) {
                var obj = eval('(' + xmlHttp1.responseText + ')');
                var temp = obj.geocodes;
                var obj2 = temp[0];
                var start_location = obj2.location;
                var end_adress = document.getElementById("end").value;
                var xmlHttp2;
                xmlHttp2 = new XMLHttpRequest();
                xmlHttp2.onreadystatechange = function () {
                    if (xmlHttp2.readyState == 4 && xmlHttp2.status == 200) {
                        var obj = eval('(' + xmlHttp2.responseText + ')');
                        var temp = obj.geocodes;
                        var obj2 = temp[0];
                        var end_location = obj2.location;
                        var xmlHttp3;
                        xmlHttp3 = new XMLHttpRequest();
                        var type = "";
                        var temp_radio = document.getElementsByName("travel_type");
                        for (var i = 0; i < temp_radio.length; i++) {
                            if (temp_radio[i].checked) {
                                type = temp_radio[i].value;
                                break;
                            }
                        }
                        if (type == 1) {
                            xmlHttp3.onreadystatechange = function () {
                                if (xmlHttp3.readyState == 4 && xmlHttp3.status == 200) {
                                    //demo中暂只显示一条推荐方案
                                    var obj = eval('(' + xmlHttp3.responseText + ')');
                                    var temp = obj.route.paths;
                                    var obj2 = temp[0];
                                    var temp2 = obj2.steps;
                                    var result = "";
                                    for (var i = 0; i < temp2.length; i++) {
                                        var obj3 = temp2[i];
                                        if (i == temp2.length - 1)
                                            result += obj3.instruction + '。';
                                        else
                                            result += obj3.instruction + '，';
                                    }
                                    document.getElementById("result").innerHTML = result;
                                }
                            }
                            xmlHttp3.open("GET", "https://restapi.amap.com/v3/direction/walking?origin=" + start_location + "&destination=" + end_location + "&key=da89dbb834cdbffe52dc14f8d62392af", true);
                            xmlHttp3.send();
                        }
                        else if (type == 2) {
                            var s1 = start_adress.indexOf("省");
                            var s2 = end_adress.indexOf("省");
                            //防止某地名中带有“省”字
                            if (s1 > 3)
                                s1 = -1;
                            if (s2 > 3)
                                s2 = -1;
                            var t1 = start_adress.indexOf("市");
                            var t2 = end_adress.indexOf("市");
                            var city1 = start_adress.substring(s1 + 1, t1);
                            var city2 = end_adress.substring(s2 + 1, t2);
                            var strategy = "";
                            var temp_radio2 = document.getElementsByName("bus");
                            for (var i = 0; i < temp_radio2.length; i++) {
                                if (temp_radio2[i].checked) {
                                    strategy = temp_radio2[i].value;
                                    break;
                                }
                            }
                            xmlHttp3.onreadystatechange = function () {
                                if (xmlHttp3.readyState == 4 && xmlHttp3.status == 200) {
                                    //demo中暂只显示一条推荐方案
                                    var obj = eval('(' + xmlHttp3.responseText + ')');
                                    var temp = obj.route.transits;
                                    var obj2 = temp[0];
                                    var temp2 = obj2.segments;
                                    var result = "";
                                    for (var j = 0; j < temp2.length; j++) {
                                        var obj3 = temp2[j];
                                        var temp3 = obj3.bus.buslines;
                                        var temp4 = obj3.walking.steps;
                                        for (var i = 0; i < temp4.length; i++) {
                                            var obj5 = temp4[i];
                                            if (i == temp4.length - 1 && j == temp2.length - 1)
                                                result += obj5.instruction + '到达终点。';
                                            else if (i == temp4.length - 1)
                                                result += obj5.instruction + '。';
                                            else
                                                result += obj5.instruction + '，';
                                        }
                                        if (temp3.length != 0) {
                                            var obj4 = temp3[0];
                                            result += "乘坐" + obj4.name + "线路，" + obj4.departure_stop.name + "上车，" + obj4.arrival_stop.name + "下车。";
                                        }
                                    }
                                    document.getElementById("result").innerHTML = result;
                                }
                            }
                            xmlHttp3.open("GET", "https://restapi.amap.com/v3/direction/transit/integrated?origin=" + start_location + "&destination=" + end_location + "&city=" + city1 + "&cityd=" + city2 + "&strategy=" + strategy + "&key=da89dbb834cdbffe52dc14f8d62392af", true);
                            xmlHttp3.send();
                        }
                        else if (type == 3) {
                            var strategy = "";
                            var temp_radio2 = document.getElementsByName("car");
                            for (var i = 0; i < temp_radio2.length; i++) {
                                if (temp_radio2[i].checked) {
                                    strategy = temp_radio2[i].value;
                                    break;
                                }
                            }
                            xmlHttp3.onreadystatechange = function () {
                                if (xmlHttp3.readyState == 4 && xmlHttp3.status == 200) {
                                    //demo中暂只显示一条推荐方案
                                    var obj = eval('(' + xmlHttp3.responseText + ')');
                                    var temp = obj.route.paths;
                                    var obj2 = temp[0];
                                    var temp2 = obj2.steps;
                                    var result = "";
                                    for (var i = 0; i < temp2.length; i++) {
                                        var obj3 = temp2[i];
                                        if (i == temp2.length - 1)
                                            result += obj3.instruction + '。';
                                        else
                                            result += obj3.instruction + '，';
                                    }
                                    document.getElementById("result").innerHTML = result;
                                }
                            }
                            xmlHttp3.open("GET", "https://restapi.amap.com/v3/direction/driving?origin=" + start_location + "&destination=" + end_location + "&strategy=" + strategy + "&key=da89dbb834cdbffe52dc14f8d62392af", true);
                            xmlHttp3.send();
                        }
                    }
                }
                xmlHttp2.open("GET", "https://restapi.amap.com/v3/geocode/geo?address=" + end_adress + "&key=da89dbb834cdbffe52dc14f8d62392af", true);
                xmlHttp2.send();
            }
        }
        xmlHttp1.open("GET", "https://restapi.amap.com/v3/geocode/geo?address=" + start_adress + "&key=da89dbb834cdbffe52dc14f8d62392af", true);
        xmlHttp1.send();
    }
</script>
</html>
