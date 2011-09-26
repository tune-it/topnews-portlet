<%
/**
* Copyright (c) 2011 Tune IT.
*/
%>

<%@ include file="./init.jsp" %>


<div class="main-news">
	<div class="news-in">
		<div class="corner-tl"></div>
		<div class="corner-tr"></div>
		<div class="corner-br"></div>
		<div class="corner-bl"></div>
		<div class="border-left"></div>
		<div class="border-top"></div>
		<div class="border-right"></div>
		<div class="border-bottom"></div>
		<div class="news-tr"></div>
		
		<span id="<portlet:namespace />news1Img" class="img">
			<img alt="<%= topNewsText %>" src="<%= topImageURL %>" class="center" width="260" height="250">
			<i></i>
		</span>
		<span id="<portlet:namespace />news2Img" class="img" style="display:none">
			<img alt="<%= middleNewsText %>" src="<%= middleImageURL %>" class="center"  width="260" height="250">
			<i></i>
		</span>
		
		<span id="<portlet:namespace />news3Img" class="img" style="display:none">		
			<img alt="<%= bottomNewsText %>" src="<%= bottomImageURL %>" class="center"  width="260" height="250">		
			<i></i>
		</span>
		
		<ul class="news">
			<li id="<portlet:namespace />news1" class="here">
				<a title="News" href="<%= topNewsURL %>"><%= topNewsText %><span><%= format.format(topNewsDate.getTime()) %></span></a>
				<i></i>
			</li>
			<li id="<portlet:namespace />news2">
				<a title="News" href="<%= middleNewsURL %>"><%= middleNewsText %><span><%= format.format(middleNewsDate.getTime()) %></span></a>
				<i></i>
			</li>
			<li id="<portlet:namespace />news3" >
				<a title="News" href="<%= bottomNewsURL %>"><%= bottomNewsText %><span><%= format.format(bottomNewsDate.getTime()) %></span></a>
				<i></i>
			</li>
		</ul>
	</div>
</div>


<script type="text/javascript">
jQuery(document).ready(function(){
	
	jQuery("ul.news li").mouseenter(
		function() {
			if ($(this).attr("id") != jQuery("li.here").attr("id")) {
				jQuery("div.news-in .img").hide();
				jQuery("li.here").removeClass("here");
				
				$(this).addClass("here");
				jQuery("#" + $(this).attr("id") + "Img").fadeIn(700);
			}
   		}
	);
	
});
</script>
