/**
 * Created by joneckstein on 12/23/15.
 */


$(function () {
    $('.tic-tac-toe-box').on("click",function(e){
        var elem = $(e.toElement);
        var xy = elem.data('ttc-xy');
        elem.text('O');

        $.ajax({
            method: "POST",
            url: "/game/move",
            data: { move: xy }
        }).done(function( msg ) {
            //console.log(msg.ai_move);
            var ai_move = msg.ai_move;
            var next_elem = $('#game').find('[data-ttc-xy="'+ ai_move +'"]');
            next_elem.text('X');
            //console.log(next_elem);
        });
    });



});


TicTacToe = {

}
