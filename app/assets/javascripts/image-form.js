	$(document).ready(function() {
		ModalInit();

		UploadInit();

		$("#submit-picture").click(function(){
			
			//we trigger the submit event
			$("#new_picture").submit();

			//we close the modal
			$("#modal-close-button").click();
			//and we are done...
			return false;
		});
	});

	/* ---- FUNCTIONS ---- */
	
	function UploadInit(){
		$("#new_picture").iframePostForm({ 
			url: 	"/advertiser/picture/create.json",
			json: 	true,
			complete : 
                    function (response) {
                        var id = $("#picture-url-id").val();
                        $("#picture-url-"+id).spin(false);

                        if(response == null){
                            $("#picture-error-container").html('<div class="alert alert-error fade in" >' + '<button class="close" data-dismiss="alert">×</button>' + '<strong>No se pudo subir la imagen!</strong> La imagen que subiste no cumple con los requisitos. </div>');
                        }else{
                            $("#picture-url-"+id).html("<img src='"+response.image.thumb.url+"' style='margin-top:16px;'/> <a target='_blank' href='http://s-t.co/P"+response.picture_code+"'> http://s-t.co/P"+response.picture_code+" </a>").load();
                            $("#tweet_group_tweets_attributes_"+id+"_text").val($("#tweet_group_tweets_attributes_"+id+"_text").val()+" http://s-t.co/P"+response.picture_code);
                            $("#tweet_group_tweets_attributes_"+id+"_text").trigger(jQuery.Event("keyup"))
                        }
                    },
			post :
					function(){
						var opts = {
						  lines: 13, // The number of lines to draw
						  length: 7, // The length of each line
						  width: 4, // The line thickness
						  radius: 10, // The radius of the inner circle
						  rotate: 0, // The rotation offset
						  color: '#000', // #rgb or #rrggbb
						  speed: 1, // Rounds per second
						  trail: 60, // Afterglow percentage
						  shadow: true, // Whether to render a shadow
						  hwaccel: false, // Whether to use hardware acceleration
						  className: 'spinner', // The CSS class to assign to the spinner
						  zIndex: 0, // The z-index (defaults to 2000000000)
						  top: 'auto', // Top position relative to parent in px
						  left: 'auto' // Left position relative to parent in px
						};
						var id = $("#picture-url-id").val();
						$("#picture-url-"+id).spin(opts);
					}	
				
		});
	}

	function ModalInit(){
        $("#previewModal").modal({
            backdrop : true,
            show : false,
            keyboard : true
        });
        $("#previewModal").hide();

		$("#myModal").modal({
			backdrop : true,
			show : false,
			keyboard : true
		});
        $("#myModal").hide();

		/*$('#myModal').on('hidden', function () {
			$("#picture_image").replaceWith($("#picture_image").clone());
		})*/
		
		$(".image-modal-trigger").click(function(){
			ModalTriggerHandler($(this));
		})

        $(".preview-modal-trigger").click(function(){
            ModalPreviewTriggerHandler();
        });
	}

    function ModalPreviewTriggerHandler(){
        var tweet

        for(var i = 0 ; i < 3 ; i++){
            var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
            tweet = "<div style='clear:both;width:100%;'>"
            tweet += "<div style='float:left'>"
            tweet +=    "<img style='width: 48px;height: 48px;-webkit-border-radius: 5px;-moz-border-radius: 5px;border-radius: 5px;' src='"+$(".twitter-user-photo img").attr("src")+"' />"
            tweet += "</div>"
            tweet += "<div style='float:left; margin-left: 6px; width:86%;'>"
            tweet += "<strong style='font-weight: bold; '>"+$(".profile_resume_head h1").html()+"</strong>"
            tweet +=    "<span class='preview-user-link' style='display: inline;'>" + $(".overview_data h2").html() + "</span>" + "<br/>"
            tweet +=    "<span style='display:inline'>" + replaceURLWithHTMLLinks($("textarea#tweet_group_tweets_attributes_"+i+"_text").val()) + "</span>"
            tweet +=    "<br/>" + "<span class='preview-user-date'>"+ " "+ tweetHour($("#tweet_group_tweets_attributes_"+i+"_tweet_at_4i").val()) + ":"+ $("#tweet_group_tweets_attributes_"+i+"_tweet_at_5i").val()+" "+ ampm($("#tweet_group_tweets_attributes_"+i+"_tweet_at_4i").val()) +" - " +$("#tweet_group_tweets_attributes_"+i+"_tweet_at_3i").val() +" "+ monthName($("#tweet_group_tweets_attributes_"+i+"_tweet_at_2i").val())+" "+$("#tweet_group_tweets_attributes_"+i+"_tweet_at_1i").val()+" "+"</span>"
            tweet += "</div>"
            tweet += "</div>"

            $("#preview-body-tweet-"+i).html(tweet).load()
        }

    }

    function tweetHour(hour){
        number = parseInt(hour);

        if(number > 12)
            return number - 12
        else
            return number;
    }

    function ampm(hour){
        number = parseInt(hour);

        if(number > 12)
            return "PM"
        else
            return "AM";
    }
    function monthName(number){
        number = parseInt(number);
        var month=new Array();
        month[1]="Ene";
        month[2]="Feb";
        month[3]="Mar";
        month[4]="Abr";
        month[5]="May";
        month[6]="Jun";
        month[7]="Jul";
        month[8]="Ago";
        month[9]="Sep";
        month[10]="Oct";
        month[11]="Nov";
        month[12]="Dic";
        return month[number]
    }

    function replaceURLWithHTMLLinks(text) {
        var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
        /*return text.replace(exp,"<a href='$1'>$1</a>");*/
        var textHtml = text;
        textHtml = textHtml.replace(/@([A-Za-z0-9_]+)/ig, "<a href='#'>@$1</a>")
        textHtml = textHtml.replace(/#([A-Za-z0-9_]+)/ig, "<a href='#'>#$1</a>")
        return textHtml.replace(exp,"<a href='#'>http://s-t.co/L1NK5</a>");
    }

	function ModalTriggerHandler(obj){
		var id = obj.attr('id').substring(15,obj.attr('id').length);
		$("#option-picture-id").val(id);
		$("#picture-error-container").html("");
	}

    function SetId(id){
        $("#picture-url-id").val(id);
    }