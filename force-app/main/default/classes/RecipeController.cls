/**
 * @description       : 
 * @author            : Narjes Mathlouthi
 * @group             : 
 * @last modified on  : 12-17-2021
 * @last modified by  : Narjes Mathlouthi
**/
public inherited sharing class RecipeController{ 
    @AuraEnabled
    public static List < Ingredient__c > generateGroceryList(ID recipeId){
        List < Ingredient__c > ingredients = [SELECT ID, Name, Measurement__c, Measurement_Type__c, Notes__c FROM Ingredient__c WHERE Recipe__c=:recipeId];return ingredients; }       
    
    @AuraEnabled
    public static void addIngredient(Decimal measurementAmount,String ingredientName, String measurementType, ID recipeId){ 
            Ingredient__c ingredient = new Ingredient__c(
            Name = ingredientName,
            Measurement__c = measurementAmount,
            Measurement_Type__c = measurementType,
            Recipe__c = recipeId
            );
            insert ingredient;
    }
    
        //Issue 3 ML
    @AuraEnabled(cacheable=true)
    public static List <Ingredient__c> scaleRecipeForServings (ID recipeId, Decimal desiredServings) {
        
            //Query for the servings value from the Recipe record
            Recipe__c recipe = [SELECT Servings__c FROM Recipe__c WHERE ID = :recipeId];
            
            //Query database for list of the ingredients needed for the recipe and store in a list
            List <Ingredient__c> initialIngredientList = [SELECT Id, Name, Measurement__c, Measurement_Type__c FROM Ingredient__c  WHERE Recipe__c = :recipeId];
            
            //Instantiate list to later store the same ingredients with updated measurements
            List <Ingredient__c> finalIngredientList = new List <Ingredient__c>();

        //Instantiate variable which determines conversion factor (divide desired servings by recipe default servings)
        Decimal conversionFactor = desiredServings/recipe.Servings__c;

        //Loop through each ingredient and update the Measurement by the conversion factor, then add to the final ingredient list
        for(Ingredient__c ingredient : initialIngredientList) {
            ingredient.Measurement__c = ingredient.Measurement__c * conversionFactor;
            finalIngredientList.add(ingredient);
        }

        //Instead of committing to the database, return the final ingredient list with the updated measurements
        return finalIngredientList;

    }
    
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
}

