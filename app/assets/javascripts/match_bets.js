// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function clear_penalty_winner_select(select_block) {
  select_block.addClass('hide');
  select_block.find(':input').val('');
}

document.addEventListener('page:change', (function(_this) {
  return function(event) {

    $('#no_draw_match_bet_form').find('.goal-guess:input').change(function(){
      var goals_a = parseInt($('#match_bet_goals_a').val(), 10);
      var goals_b = parseInt($('#match_bet_goals_b').val(), 10);
      var select_block = $('#penalty-winner-selector');

      if (isNaN(goals_a)) {
        clear_penalty_winner_select(select_block);
        return;
      }
      if (isNaN(goals_b)) {
        clear_penalty_winner_select(select_block);
        return;
      }

      if (goals_a == goals_b) {
        select_block.removeClass('hide');
      } else {
        clear_penalty_winner_select(select_block);
      }
    });

  };
})(this));
