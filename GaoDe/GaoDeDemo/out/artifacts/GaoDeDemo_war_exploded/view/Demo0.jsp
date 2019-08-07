<%--
  Created by IntelliJ IDEA.
  User: TXT
  Date: 2019/8/6
  Time: 13:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">
    <title>游戏周边</title>
    <link rel="stylesheet" href="https://a.amap.com/jsapi_demos/static/demo-center/css/demo-center.css"/>
    <link rel="stylesheet" type="text/css" href="../css/Demo0.css"/>
    <style>
        html, body, #container {
            height: 100%;
        }
    </style>
</head>
<body>
<div id='container'></div>
<script type="text/javascript"
        src="https://webapi.amap.com/maps?v=1.4.15&key=da89dbb834cdbffe52dc14f8d62392af"></script>
<script type="text/javascript">
    var map = new AMap.Map('container', {
        resizeEnable: true
    });
    //静态，连接好数据库后需修改
    var markers = [{
        content: '<img src="../img/mlxg.png" style="width:36px;height:36px"/>',
        position: [120.735464, 31.265736]
    }, {
        content: '<img src="../img/wangzhe.png" style="width:36px;height:36px"/>',
        position: [120.748027, 31.26392]
    }, {
        content: '<img src="../img/wangzhe.png" style="width:36px;height:36px"/>',
        position: [120.751681, 31.256647]
    }];
    var titles = [
        'mlxg周边专售',
        '张博文的游戏周边店',
        '马瑞辰的游戏代练店'
    ];
    var contents = [
        "<img src='http://tpc.googlesyndication.com/simgad/5843493769827749134'>地址：江苏省苏州市吴中区苏州创意产业园<br/>电话：17854289233<br/><a href='https://ditu.amap.com/detail/B000A8URXB?citycode=110105'>详细信息</a>",
        "<img src='http://tpc.googlesyndication.com/simgad/5843493769827749134'>地址：江苏省苏州市吴中区文萃公寓四栋<br/>电话：17863969210<br/><a href='https://ditu.amap.com/detail/B000A8URXB?citycode=110105'>详细信息</a>",
        "<img src='http://tpc.googlesyndication.com/simgad/5843493769827749134'>地址：江苏省苏州市吴中区外包服务学院八号楼<br/>电话：17854207542<br/><a href='https://ditu.amap.com/detail/B000A8URXB?citycode=110105'>详细信息</a>"
    ];
    //用户当前坐标
    var userPosition=null;
    //定义插件
    AMap.plugin('AMap.Geolocation', function () {
        var geolocation = new AMap.Geolocation({
            enableHighAccuracy: true,//是否使用高精度定位，默认:true
            timeout: 10000,          //超过10秒后停止定位，默认：5s
            buttonPosition: 'RB',    //定位按钮的停靠位置
            buttonOffset: new AMap.Pixel(-18, -36),//定位按钮与设置的停靠位置的偏移量，默认：Pixel(10, 20)
            markerOptions: {//自定义定位点样式，同Marker的Options
                'content': '<img src="https://a.amap.com/jsapi_demos/static/resource/img/user.png" style="width:36px;height:36px"/>'
            },
            zoomToAccuracy: true,   //定位成功后是否自动调整地图视野到定位点
        });
        map.addControl(geolocation);
        geolocation.getCurrentPosition(function (status, result) {
            if(status=='complete'){
                onComplete(result)
            }else{
                onError(result)
            }
        });
    });
    //定位成功后业务逻辑
    function onComplete(data) {
        var i = 0;
        var userPosition=data.position;
        markers.forEach(function (marker) {
            var markInstance = new AMap.Marker({
                map: map,
                content: marker.content,
                position: [marker.position[0], marker.position[1]],
                offset: new AMap.Pixel(-18, -36),
                animation: "AMAP_ANIMATION_BOUNCE"
            });
            //测算与各定点之间的距离
            var salePosition = markInstance.getPosition();
            var distance = Math.round(userPosition.distance(salePosition));
            titles[i]+=("<span style='font-size:11px;color:#F00;'>距您");
            titles[i]+=(distance);
            titles[i]+=("米</span>");
            //创建自定义窗体
            var infoWindow = new AMap.InfoWindow({
                isCustom: true,  //使用自定义窗体
                content: createInfoWindow(titles[i], contents[i]),
                offset: new AMap.Pixel(16, -45)
            });
            //鼠标点击marker弹出自定义的信息窗体（设置监听事件）
            AMap.event.addListener(markInstance, 'click', function () {
                infoWindow.open(map, salePosition);
            });
            i++;
        });
    }
    //解析定位错误信息
    function onError(data) {
        document.getElementById('status').innerHTML='定位失败'
        document.getElementById('result').innerHTML = '失败原因排查信息:'+data.message;
    }


    //构建自定义信息窗体
    function createInfoWindow(title, content) {
        var info = document.createElement("div");
        info.className = "custom-info input-card content-window-card";

        //可以通过下面的方式修改自定义窗体的宽高
        //info.style.width = "400px";
        // 定义顶部标题
        var top = document.createElement("div");
        var titleD = document.createElement("div");
        var closeX = document.createElement("img");
        top.className = "info-top";
        titleD.innerHTML = title;
        closeX.src = "https://webapi.amap.com/images/close2.gif";
        closeX.onclick = closeInfoWindow;

        top.appendChild(titleD);
        top.appendChild(closeX);
        info.appendChild(top);

        // 定义中部内容
        var middle = document.createElement("div");
        middle.className = "info-middle";
        middle.style.backgroundColor = 'white';
        middle.innerHTML = content;
        info.appendChild(middle);

        // 定义底部内容
        var bottom = document.createElement("div");
        bottom.className = "info-bottom";
        bottom.style.position = 'relative';
        bottom.style.top = '0px';
        bottom.style.margin = '0 auto';
        var sharp = document.createElement("img");
        sharp.src = "https://webapi.amap.com/images/sharp.png";
        bottom.appendChild(sharp);
        info.appendChild(bottom);
        return info;
    }

    //关闭信息窗体
    function closeInfoWindow() {
        map.clearInfoWindow();
    }
</script>
</body>
</html>
