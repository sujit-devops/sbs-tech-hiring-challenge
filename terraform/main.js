/* main.js */

function get_data () {
        
    // define our API gateway here...
    //var url = "https://x1cwvutiw7.execute-api.us-east-1.amazonaws.com/default/myfunction";
    var url = "__API_URL__";
    var str = "";

    // use jquery ajax function to get our data...
    //
    $.ajax({
        url: url, 
        dataType: 'json',
        data: '',
        //headers: {'Access-Control-Allow-Origin': '*',},
        crossDomain: true,
        success: function(result) {
            
            console.log (JSON.stringify(result));
            
            str = "Date on Webserver " + result.ip + " is " + result.date;
            $("#data_string").html(str);
            
        }});
}