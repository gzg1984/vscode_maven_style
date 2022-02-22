<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="front_style.jsp"%>
<link rel="stylesheet" href="<%=contextPath%>/assets/css/index.css" />
<title>Troob 精确认知</title>
  <style>
        ul {
            width: 2000%;
            position: absolute;
            list-style: none;
            left:0;
            top: 0;
        }
 
        ol {
            position: absolute;
            height: 20px;
            right: 20px;
            bottom: 20px;
            text-align: center;
            padding: 5px;
        }
        ol li{
            display: inline-block;
            width: 20px;
            height: 20px;
            line-height: 20px;
            background-color: #fff;
            margin: 5px;
            cursor: pointer;
 
        }
        ol .current{
            background-color: red;
        }
        #arr{
            display: none;
        }
        #arr span{
            width: 40px;
            height: 40px;
            position: absolute;
            left: 5px;
            top: 50%;
            margin-top: -20px;
            background: #fff;
            cursor: pointer;
            line-height: 40px;
            text-align: center;
            font-weight: bold;
            font-family: '黑体';
            font-size: 30px;
            color: #000;
            opacity: 0.5;
            border: 1px solid #fff;
        }
        #arr #right {
            right: 5px;
            left: auto;
        }
    </style>

</head>
<body>
	<!-- header start-->
	<%@ include file="front_header.jsp"%>
	<!-- header end-->
	<!-- main content start -->
	<div class="content">
		<div class="content-wrapper">
			<div class="solid-btm pad-30-bottom clearfix">
			<div class="explore-box" id="e-box">
					<div class="inner">
					<!--轮播图-->
					<ul>
					<li><a href="#"><img src="images/1.jpg" alt=""></a></li>
					<li><a href="http://backup.troob.cn"><img src="images/2.jpg" alt=""></a></li>
					</ul>

					<ol class="bar"> </ol>
					<!--左右焦点-->
					<div id="arr">
					<span id="left"> 《 </span>
					<span id="right"> 》 </span>
					</div>
			</div>
<script>
    /**
     * @param id  传入元素的id
     * @returns {HTMLElement | null}  返回标签对象，方便获取元素
     */
    function my$(id) {
        return document.getElementById(id);
    }
 
    //获取各元素，方便操作
    var box=my$("e-box");
    var inner=box.children[0];
    var ulObj=inner.children[0];
    var list=ulObj.children;
    var olObj=inner.children[1];
    var arr=my$("arr");
    var imgWidth=inner.offsetWidth;
    var right=my$("right");
    var pic=0;
    //根据li个数，创建小按钮
    for(var i=0;i<list.length;i++){
        var liObj=document.createElement("li");
 
        olObj.appendChild(liObj);
        liObj.innerText=(i+1);
        liObj.setAttribute("index",i);
 
        //为按钮注册mouseover事件
        liObj.onmouseover=function () {
            //先清除所有按钮的样式
 
            for (var j=0;j<olObj.children.length;j++){
                olObj.children[j].removeAttribute("class");
            }
            this.className="current";
            pic=this.getAttribute("index");
            animate(ulObj,-pic*imgWidth);
        }
 
    }
 
 
    //设置ol中第一个li有背景颜色
    olObj.children[0].className = "current";
    //克隆一个ul中第一个li,加入到ul中的最后=====克隆
    ulObj.appendChild(ulObj.children[0].cloneNode(true));
 
    var timeId=setInterval(onmouseclickHandle,3000);
    //左右焦点实现点击切换图片功能
    box.onmouseover=function () {
        arr.style.display="block";
        clearInterval(timeId);
    };
    box.onmouseout=function () {
        arr.style.display="none";
        timeId=setInterval(onmouseclickHandle,3000);
    };
 
    right.onclick=onmouseclickHandle;
    function onmouseclickHandle() {
        //如果pic的值是5,恰巧是ul中li的个数-1的值,此时页面显示第六个图片,而用户会认为这是第一个图,
        //所以,如果用户再次点击按钮,用户应该看到第二个图片
        if (pic == list.length - 1) {
            //如何从第6个图,跳转到第一个图
            pic = 0;//先设置pic=0
            ulObj.style.left = 0 + "px";//把ul的位置还原成开始的默认位置
        }
        pic++;//立刻设置pic加1,那么此时用户就会看到第二个图片了
        animate(ulObj, -pic * imgWidth);//pic从0的值加1之后,pic的值是1,然后ul移动出去一个图片
        //如果pic==5说明,此时显示第6个图(内容是第一张图片),第一个小按钮有颜色,
        if (pic == list.length - 1) {
            //第五个按钮颜色干掉
            olObj.children[olObj.children.length - 1].className = "";
            //第一个按钮颜色设置上
            olObj.children[0].className = "current";
        } else {
            //干掉所有的小按钮的背景颜色
            for (var i = 0; i < olObj.children.length; i++) {
                olObj.children[i].removeAttribute("class");
            }
            olObj.children[pic].className = "current";
        }
    }
    left.onclick=function () {
        if (pic==0){
            pic=list.length-1;
            ulObj.style.left=-pic*imgWidth+"px";
        }
        pic--;
        animate(ulObj,-pic*imgWidth);
        for (var i = 0; i < olObj.children.length; i++) {
            olObj.children[i].removeAttribute("class");
        }
        //当前的pic索引对应的按钮设置颜色
        olObj.children[pic].className = "current";
    };
 
    //设置任意的一个元素,移动到指定的目标位置
    function animate(element, target) {
        clearInterval(element.timeId);
        //定时器的id值存储到对象的一个属性中
        element.timeId = setInterval(function () {
            //获取元素的当前的位置,数字类型
            var current = element.offsetLeft;
            //每次移动的距离
            var step = 25;
            step = current < target ? step : -step;
            //当前移动到位置
            current += step;
            if (Math.abs(current - target) > Math.abs(step)) {
                element.style.left = current + "px";
            } else {
                //清理定时器
                clearInterval(element.timeId);
                //直接到达目标
                element.style.left = target + "px";
            }
        }, 25);
    }
</script>

				</div>
			<c:if test="${not empty sessionScope.loginUser }">
				<div class="index-project-box">
					<ul class="nav nav-tabs" role="tablist">
						<li role="presentation" class="active"><a href="#commented"
							aria-controls="commented" role="tab" data-toggle="tab">已备注<span
								class="badge">${commentCount }</span></a></li>
						<li role="presentation"><a href="#favorate"
							aria-controls="favorate" role="tab" data-toggle="tab">已收藏<span
								class="badge">${favCount }</span></a></li>
					</ul>
					<div class="tab-content">
						<div role="tabpanel" class="tab-pane active" id="commented">
							<ul class="index-project-list">
								<c:forEach var="comment" items="${commentList }">
									<li>
									<a href="<%=contextPath%>/project/${comment.projectVO.titleEn}">
									<i class="glyphicon glyphicon-folder-open"></i>${comment.projectVO.title}</a>
									<a class="pull-right text-right file-name" href="<%=contextPath%>/project${comment.fileVO.filePath}">
										${comment.fileVO.fileName }:${comment.lineNumber+1 }
									</a>
									</li>
								</c:forEach>
							</ul>
							<p class="more text-right">
								<a href="<%=contextPath%>/user/comments.html">更多>></a>
							</p>
						</div>
						<div role="tabpanel" class="tab-pane" id="favorate">
							<ul class="index-project-list">
								<c:forEach var="fav" items="${favList }">
									<li><a href="<%=contextPath%>/project/${fav.projectVO.titleEn}"><i class="glyphicon glyphicon-folder-open"></i>${fav.projectVO.title}</a></li>
								</c:forEach>
							</ul>
							<p class="more">
								<a href="<%=contextPath%>/user/fav.html">更多>></a>
							</p>
						</div>
					</div>
				</div>
				</c:if>
			<c:if test="${empty sessionScope.loginUser }">
				<div class="index-login-box">
					<div class="box-head">
						登录
					</div>
					<div class="tab-content">
					<form id="loginForm" action="<%=contextPath%>/login" method="post">
						<input name="url" value="index.html" type="hidden">
						<p class="input-control"><span class="glyphicon glyphicon-user"></span><input type="text" name="username" placeholder="请输入用户名"></p>
						<p class="input-control"><span class="glyphicon glyphicon-lock"></span><input type="password" name="password" placeholder="请输入密码"></p>
						<p class="forgot"><a href="forget.html">忘记密码?</a></p>
						<p class="login-btn"><button id="btnLogin" type="submit" class="btn btn-sm btn-danger">登录</button></p>
					</form>
					</div>
				</div>
				</c:if>
			</div>
			<div class="pane mar-25-bottom mar-20-top">
				<div class="pane-title">
					<span class="glyphicon glyphicon-list"></span>最新备注<a
						href="new" class="gray-link">更多</a>
				</div>
				<div class="pane-content clearfix">
					<div class="hot-project file">
					<c:forEach items="${recentFiles }" var="file">
						<div>
							<p class="half-title clearfix">
								<a class="gray ellipsis" href="<%=contextPath%>/project${file.filePath}"><span class="fa fa-file-code-o mar-10-right"></span>${file.fileName }</a>
								<a class="red-title text-right" href="<%=contextPath%>/project/${file.projectTitleEn}">${file.projectTitle }</a>
							</p>
							<p class="comment-info">
								<span class="mar-0-left gray pull-left">${file.lastCommentTimeRelative }</span>
								<span class="weekly">最近一周<font class="num">${file.weeklyCommentCount }</font></span><span  class="total">累计备注<font
									class="num">${file.commentCount }</font></span>
							</p>
						</div>
					</c:forEach>
					</div>
				</div>
			</div>
			<div class="pane mar-25-bottom mar-20-top">
				<div class="pane-title">
					<span class="glyphicon glyphicon-list"></span>最热文件<a
						href="hot_file" class="gray-link">更多</a>
				</div>
				<div class="pane-content clearfix">
					<div class="hot-project file">
					<c:forEach items="${hotFiles }" var="file">
						<div>
							<p class="half-title clearfix">
								<a class="gray ellipsis" href="<%=contextPath%>/project${file.filePath}"><span class="fa fa-file-code-o mar-10-right"></span>${file.fileName }</a>
								<a class="red-title text-right" href="<%=contextPath%>/project/${file.projectTitleEn}">${file.projectTitle }</a>
							</p>
							<p class="comment-info">
								<span class="weekly">最近一周<font class="num">${file.weeklyCommentCount }</font></span ><span class="total">累计备注<font
									class="num">${file.commentCount }</font></span>
							</p>
						</div>
					</c:forEach>
					</div>
				</div>
			</div>
			<div class="pane mar-25-bottom mar-20-top">
				<div class="pane-title">
					<span class="glyphicon glyphicon-list"></span>最热项目<a
						href="hot" class="gray-link">更多</a>
				</div>
				<div class="pane-content clearfix">
					<div class="hot-project">
					<c:forEach items="${hotProjects }" var="hot">
						<div>
								<p class="red-title ellipsis">
									<a href="<%=contextPath%>/project/${hot.titleEn}">${hot.title }</a>
									<a href="<%=contextPath%>/detail/${hot.projectId}"><span class="glyphicon glyphicon-exclamation-sign"></span></a>
									
								</p>
								<div class="ellipsis-4 gray-content">${hot.desc }</div>
								<p class="comment-info">
									<span class="weekly">最近一周<font class="num">${hot.weeklyCommentCount }</font></span ><span class="total">累计备注<font
										class="num">${hot.commentCount }</font></span>
								</p>
						</div>
					</c:forEach>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="front_footer.jsp"%>
	<!-- main content end -->
	<%@ include file="script.jsp"%>
	<!-- Login mini window, will be shown if we click login button -->
	<script type="text/javascript" src="<%=contextPath %>/assets/js/user/login.js"></script>
	<script>
	$(document).ready(function(){
// 		 PR.prettyPrint();
	});
	</script>
</body>
</html>
