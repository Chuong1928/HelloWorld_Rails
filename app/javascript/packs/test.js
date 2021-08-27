//console.log(123);
$("#micropost_image").bind("change", function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
         alert("Maximum file size is 5MB. Please choose a smaller file.");
    }
});

$(document).on('click', '.follow',function(){
    
    let followed_id = $(this).attr("data-follow-id")
    // console.log(new_comment);
    console.log("1234");
    $.ajax({
        url: `/relationships`,
        data: {
            tag: {
                followed_id: followed_id
            },
            authenticity_token: AUTH_TOKEN
        },
        type: 'POST',
        dataType: 'script',
    }).done(function (data) {
        console.log(data);
    }).fail(function () {
        console.log("thất bại");
    })
})