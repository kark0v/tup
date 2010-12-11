document.observe('dom:loaded', function(){
	Cufon.replace('h2,h3,h4');
	$$("h2,h3,h4").setStyle({ "font-weight": "bold", "margin": "300px" });
});
