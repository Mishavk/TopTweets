/**
 * Created by mkachan on 07.06.2019.
 */
({
    getText: function (component, event, helper){
        var text = event.getParam("textPost");
        var id = event.getParam("id");

        component.set("v.text", text);
        component.set("v.id", id);

        console.log('text = -->' + text);
        console.log('id = -->' + id);
    },
    goToTwitter : function(component, event, helper) {
        console.log("Start -> goToTwitter");
        var id = component.get("v.id");
        if (id == 'Some Author')
            id = "home";

        window.open("https://twitter.com/" + id);

        console.log("Start -> goToTwitter");
    }
})