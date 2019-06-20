/**
 * Created by mkachan on 05.06.2019.
 */

public with sharing class TwitterResults {
    public Long id;
    public String screen_name;
    public String id_str;
    public String text;
    public Integer favorite_count;


    public static List<TwitterResults> parse(String json) {

        return(List<TwitterResults>) System.JSON.deserialize(json, List<TwitterResults>.class );



    }
}