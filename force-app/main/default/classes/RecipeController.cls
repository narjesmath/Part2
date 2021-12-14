/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-14-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public inherited sharing class RecipeController {
    @AuraEnabled(Cacheable=true)
    public static Recipe__c[] getAllRecipes() {
        return [
            SELECT
                Id,
                Name,
                Draft__c,
                Active_Time__c,
                Active_Time_Units__c,
                Complexity__c,
                Needs_Review__c,
                Possible_Duplicate__c,
                Season__c
            FROM Recipe__c
            ORDER BY Name
            LIMIT 50
        ];
    }

    @AuraEnabled(Cacheable=true)
    public static Recipe__c[] searchRecipes(String searchTerm) {
        // Return all recipes when no search term
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            System.debug('returning: '+getAllRecipes());
            return getAllRecipes();
        }
        // Prepare query paramters
        searchTerm = '%' + searchTerm + '%';
        // Execute search query
        return [
            SELECT
                Id,
                Name,
                Draft__c,
                Active_Time__c,
                Active_Time_Units__c,
                Complexity__c,
                Needs_Review__c,
                Possible_Duplicate__c,
                Season__c
            FROM Recipe__c
            WHERE Name LIKE :searchTerm
            ORDER BY Name
            LIMIT 50
        ];
    }
    @AuraEnabled
    public static List < Ingredient__c > generateGroceryList(ID recipeId){
        //from the recipe id I get the list of ingredients
        List < Ingredient__c > myingredientlist = SELECT[Id, Name, Measurement__c, Measurement_Type__c, Notes__c from Ingredient__c WHERE Recipe__c = :recipeId];
        //once I get the list of ingredients I create a list of groceries with the ingredients needed
        List<String> mygrocerylist = new List<string>();
        for(Ingredient__c i:myingredientlist){
            mygrocerylist.add(i.Name,i.Measurement__c, i.Measurement_Type__c,i.Notes__c);
    
            system.debug('Grocery list: ' + mygrocerylist);
            return GroceryList;
        }
        
    
    }
    }
    