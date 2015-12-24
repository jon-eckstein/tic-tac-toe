/**
 * Created by joneckstein on 12/23/15.
 */


$(function () {
    $('.tic-tac-toe-box').on("click",function(e){
        var elem = $(e.toElement);
        if (elem.is(':empty') && _game_over === false){
            var xy = elem.data('ttc-xy');
            elem.text(_player_token);
            getNextAIMove(xy);
        }
    });

    if(_offense === true && _didFirstMove === false){
        getNextAIMove(null);
        _didFirstMove = true;
    }

   function getNextAIMove(xy){
       $.ajax({
           method: "POST",
           url: "/game/move",
           data: { move: xy }
       }).done(function( msg ) {
           if(msg.ai_move){
               var next_elem = $('#game').find('[data-ttc-xy="'+ msg.ai_move +'"]');
               next_elem.text(_ai_token);
           }

           if(msg.game_over){
               _game_over = true;
               $('#game-result').removeClass('hidden');
               $('#game-result-' + msg.state).removeClass('hidden');
           }

       });
   }
});