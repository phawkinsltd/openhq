$(function(){
    var search_hash_changed = false;

    App.onPageLoad(function() {
        addWarmdown();
    });

    $(window).on('hashchange', function() {
        search_hash_changed = true;

        $(document).trigger('dialogs:close');
        addWarmdown();
    });

    function addWarmdown() {
        var hash = window.location.hash,
            $target = false;

        if (!hash) return;

        hash = hash.split(':');

        if (hash[0] == "#task") {
            $target = $('.tasks li[data-id='+hash[1]+']');
            // if the task has been completed, click the show completed tasks
            // button to make sure that it can be seen on screen
            if ($target.hasClass('complete')) {
                $('.show-completed-tasks').click();
            }
        }
        else if (hash[0] == "#comment") {
            $target = $('article.comment-row[data-id='+hash[1]+']');
        }
        else if (hash[0] == "#attachment") {
            $target = $('.file-list li[data-id='+hash[1]+']');
        }

        if ($target && $target.length) {
            if (search_hash_changed) {
                performWarmdown($target);
            } else {
                $(document).on('page:loaded', function(){
                    performWarmdown($target);
                });
            }
        }
    }

    function performWarmdown($target) {
        $target.addClass('warmdown');

        $('html,body').animate({
          scrollTop: ($target.offset().top - 100)
        }, 300);

        setTimeout(function() {
            $target.removeClass('warmdown');
        }, 3000);
    }
});