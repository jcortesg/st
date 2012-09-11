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
                            $("#picture-url-"+id).html("<img src='"+response.image.thumb.url+"' style='margin-top:16px;'/> <a target='_blank' href='http://bwn.tw/P"+response.picture_code+"'> http://bwn.tw/P"+response.picture_code+" </a>").load();
                            $("#tweet_group_tweets_attributes_"+id+"_text").val($("#tweet_group_tweets_attributes_"+id+"_text").val()+" http://bwn.tw/P"+response.picture_code);
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
            tweet = "<div style='clear:both'>";
            tweet += "<div style='width:100; float:left'>";
            tweet +=    $(".twitter_photo").html()
            tweet += "</div>"
            tweet += "<div style='float:left'>"
            tweet +=    "<br/>" + $(".overview_data h2").html()
            tweet +=    "<span style='display:inline'>" + $("textarea#tweet_group_tweets_attributes_"+i+"_text").val() + "</span>";
            tweet +=    "<br/>" + $("#tweet_group_tweets_attributes_"+i+"_tweet_at_3i").val() +"/"+ $("#tweet_group_tweets_attributes_"+i+"_tweet_at_2i").val()+"/"+$("#tweet_group_tweets_attributes_"+i+"_tweet_at_1i").val()+" "+$("#tweet_group_tweets_attributes_"+i+"_tweet_at_4i").val() + ":"+ $("#tweet_group_tweets_attributes_"+i+"_tweet_at_5i").val() ;
            tweet += "</div>"
            tweet += "</div>";

            $("#preview-body-tweet-"+i).html(tweet).load();
        }

    }

	function ModalTriggerHandler(obj){
		var id = obj.attr('id').substring(15,obj.attr('id').length);
		$("#option-picture-id").val(id);
		$("#picture-error-container").html("");
	}

    function SetId(id){
        $("#picture-url-id").val(id);
    }