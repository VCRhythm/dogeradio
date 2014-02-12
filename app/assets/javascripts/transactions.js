$(document).ready(function(){
	$("#scrollingText").smoothDivScroll({
		autoScrollingMode: "always",
		autoScrollingDirection: "endlessLoopRight",
		autoScrollingStep: 1,
		autoScrollingInterval: 10,
		getContentOnLoad: {
			method: "getAjaxContent",
			content: "recent_tips",
			manipulationMethod: "replace"
		}
	}).on("mouseover", function(){
		$(this).smoothDivScroll("stopAutoScrolling");
	}).on("mouseout", function(){
		$(this).smoothDivScroll("startAutoScrolling");
	});
});
