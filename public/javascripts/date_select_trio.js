document.observe("dom:loaded", function() {

    function toggleEnableOfDateInputs(element){
        var parent = $(element.parentNode);

        var valid_from_li = Element.next(parent);
        var i1 = valid_from_li.down().next('input');

        var valid_to_li = Element.next(valid_from_li);
        var i2 = valid_to_li.down().next('input');

        var disable = element.selectedIndex != 0;

        if (disable) {
            var periodName = element.options[element.selectedIndex].value;
            i1.value = CalendarSelector[periodName]['start'];
            i2.value = CalendarSelector[periodName]['end'];
            i1.next('img').hide();
            i2.next('img').hide();
        } else {
            i1.next('img').show();
            i2.next('img').show();
        }

        i1.disabled = disable;
        i2.disabled = disable;

    }

    $$('.date_range_select').each(toggleEnableOfDateInputs);

    $(document.body).observe("change", function(event) {
        var element = event.findElement();

        if(Element.hasClassName(element, 'date_range_select')) {
            toggleEnableOfDateInputs(element);
            
            event.stop();
            return false;
        }
        return false;

    });
});