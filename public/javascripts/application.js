// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function mark_screenshot_for_destroy (element){
  $(element).next('.should_destroy').value = 1;
  $(element).up('.edit_screenshot').hide();
}

function toggle_div_display(element){
  var el = document.getElementById(element);
  Effect.toggle(el, 'slide');
  new Validation("review_form", { immediate: true });
}

function new_review()
{
  toggle_div_display('new_review');
  var el = document.getElementById('add_review');
  $(el).innerHTML = ($(el).innerHTML == 'Add another review!' ? '' : 'Add another review!');
  new Validation("review_form", { immediate: true });
}

function new_review_comment(review_id)
{
  toggle_div_display('new_comment'+review_id);
  var el = $$('.add'+review_id);
  el.each(function(e){
    $(e).innerHTML = ($(e).innerHTML == 'Add Comment' ? '' : 'Add Comment');
  });
  new Validation("comment_form", { immediate: true });
}

function show_hide_comments(element, review_id)
{
  toggle_div_display('show_comment'+review_id);
  $(element).innerHTML = ($(element).innerHTML == 'Show Comments' ? 'Hide Comments' : 'Show Comments');
}

function show_comments(element)
{
  var el = document.getElementById(element);
  if( !$(el).visible())
  {
    Effect.toggle(el, 'slide');
  }
}

function inbox_filter(type)
{
	var invisibles = $$('li.suggestions');
	var visibles = null;
	
  switch(type) {
		case 'all':
			visibles = $$('li.suggestions');
			break;
		case 'unseen':
			visibles = $$('li.unseen');
			break;
		case 'people':
			visibles = $$('li.people');
			break;
		case 'websites':
			visibles = $$('li.websites');
			break;
		case 'jobs':
			visibles = $$('li.jobs');
			break;			
		case 'books':
			visibles = $$('li.books');
			break;			
	}
	
	invisibles.invoke('hide');
	visibles.invoke('show');
}

function booklists_filter(type)
{
	var invisibles = $$('li.books');
	var visibles = null;
	
  switch(type) {
		case 'all':
			visibles = $$('li.books');
			break;
		case 'finished':
			visibles = $$('li.status_1');
			break;
		case 'reading':
			visibles = $$('li.status_2');
			break;
		case 'reference':
			visibles = $$('li.status_3');
			break;			
		case 'wanttoread':
			visibles = $$('li.status_4');
			break;			
		case 'abandoned':
			visibles = $$('li.status_5');
			break;			
	}
	
	invisibles.invoke('hide');
	visibles.invoke('show');
}

function show_notice()
{
	$('notice').addClassName('show');
	new Effect.SlideDown('notice', {duration: 2.0 });
	setTimeout("hide_notice();", 6000);
}

function hide_notice()
{
	if($('notice').hasClassName('show')) {
		new Effect.SlideUp('notice', {duration: 2.0 });
		setTimeout("$('notice').removeClassName('show')", 2000);
	}
}

document.observe("dom:loaded", function() {

	// perform validations for all forms
	$$('.frm, .validate').each(function(el){
		new Validation(el, { immediate: true });
	});
	
	// feedback form
	$$('#feedback-send, #feedback-cancel').invoke("hide");
	Event.observe('feedback-textarea', 'focus', function(ev){
	  $(this).clear();
	  $('feedback').morph('height: 200px');
	  $('feedback-textarea').morph('height: 150px');
	  $$('#feedback-send, #feedback-cancel').invoke("show");
	});
	
	Event.observe('feedback-cancel', 'click', function(ev){
	  $('feedback-textarea').value = "Don't be shy :)"; // not working
	  $('feedback').morph('height: 40px');
	  $('feedback-textarea').morph('height: 15px');
	  $$('#feedback-send, #feedback-cancel').invoke("hide");
	  ev.stop();
	  return false;
	});
	
});
