# ANF Code Test
### Project Completed by Justin Goulet

## Overview
This project was completed on January 28, 2025 by Justin Goulet. The goal of the project was to create a basic application in Swift for iOS tht would showcase a list of promotions (and their content) and allow users the ability to learn more about the promotion by simply tapping a button. If a user wanted to learn more about the restrictions on the promtion, the user would have the ability to open the associated link in the bottom description field. For full project requirements and design specs, please see the attached [document](/A%20and%20F%20Apps%20Code%20Test.pdf).

## Constraints and Requirements
While working on this project, note that we should keep in mind the following constraints of the project. These will factor into our decisions when progressing.
- iOS 14.5
  - This one is key as SwiftUI is relatively new at this stage, in addition, we have to ensure we support a wide range of versions of iOS in our code (since 18 is the latest)
- Storyboard
  - The project is currently built with a storyboard & prototype cells. Since we are tasked with just updating the view (and not making drastic architecture changes)
- The architecture pattern provided is MVC. 
  - We will try to stick with MVC, but inflate it a little to accommodate the scaling requirements of the application
- Should use Git throughout the process
- Should allow for 0 -> Many product cards safely 

## Steps to Completion
### Part 1: Fix the Crash
The first assignment was to fix a crash that was caused based on the storyboard-associated cell. The simple crash was that the identifier was of camel case, not capital case. Fixing the simple character in the view was able to resolve that crash easily.

While many identifiers are normally reverse domain, the approach was to follow "KISS", or "Keep It Simple, Stupid". Since we do not have references to other domains in a parent application, the simplest scenario was either changing the id to the value in the storyboard or the value in the table delegate method when constructing the cell.

### Part 2: Read from JSON and Update the Cell
The next step was to understand how the JSON worked. Initially, the view was pulling in the JSON object array into a raw dictionary for use in the application. This was troublesome as it was not type safe, and was very prone to error - both on the developer side and the application side. 

In order to ensure our data matched a consistent contract, the [exploreData](/ANF%20Code%20Test/exploreData.json) file was reviewed for contract validation. The final contract can be found in [Promotion.swift](/ANF%20Code%20Test/Models/Promotion.swift) and [PromotionContent.swift](/ANF%20Code%20Test/Models/PromotionContent.swift). These structures adhere to the Codable Protocol that uses customized keys and enhancements to extend the contract, in addition to applying simple JSONSerialization technique to parse the data. 

> Note that these models will also be used in Part 3, where the API will be added.

Next, we wanted to update the cell in order to show more dynamic content. This cell follows the same requirements as earlier, having the key components being a resizable image view (based on the aspect ratio of the image), a clickable label for additional details, some customized buttons and finally some additional labels. The table below shows the before and after for each of the cells.

The new cells were created in the storyboard to be aligned with the initial view, however, due to the dynamic nature of what the promotions contain, the constraints for the layout are all handled in the code.

| Before                                                               | After                                                               |
| -------------------------------------------------------------------- | ------------------------------------------------------------------- |
| ![Before Image](/imgs/Screenshot%202025-01-28%20at%202.11.13 PM.png) | ![After Image](/imgs/Screenshot%202025-01-28%20at%202.11.47 PM.png) |

> The content is different as the first image also reads data from the provided file, where the cell on the right fetches data from the API. See next step for further details on the data differences.

Finally, we need to start considering our tests, as the view has changed. The tests have been updated to match the new cell contents.

### Part 3: API Driven Data
Finally, this project now needs to scale to fetch the data from the API. For this step, we are first going to get rid of the existing launch data parsed from the JSON for consideration, however, keep our models for use in the API. 

To start with our new API integration, we need to first see how the request will work. The API is mentioned in the requirements, so the first thing we needed to do was to break out the REST client into a class in addition to creating our domain, requests and response contracts. All of these files are available for review [here](/ANF%20Code%20Test/Models/API/).

While there is a lot of skeleton code, the important part is that this application should be scalable to add additional features and requests in the future. Those models help with that as we now have a setup domain, used to fetch more explore data (and update). Other domains may be added, such as User, Cart, Data, Orders, etc. that will help organize the available requests in the application. 

When we get the data back from the REST client into our application, we now can see the key difference: the images are now URLs. This means that we now have top update our iamge loading functionality to load from files to now async image loading. For this functionality, I created an [ImageProvider](/ANF%20Code%20Test/Models/API/Images/ImageProvider.swift) with special extensions that allow us to easily fetch remote images with a placeholder - even with animations. This is similar to the new SwiftUI AsyncImage View that is not available in this project due to the above constraints.

### Part 4: Update Tests
Finally, our project called for us to make sure that we updated our tests and added some more in order to address our new functionality. A new target was added so that we could test some of the new actions on the view, in addiiton to the original tests being updated to ensure that they match our new UI requirements.

### Conclusion
While there are many decisions that came along during the project, many were tied to the project requirements. Things like Loading Views, Zero/Empty State Views, dynamic placeholders and Analytics were all omitted to stick to the formal requirments of the project, however, could easily be added.

If you have any further questions on the project or would like additional information, please reach out to [justin.goulet@aolcom](mailto:justin.goulet+anf@aol.com) and I would be happy to assist. Thank you.

- Justin Goulet