# Product Documentation: Screen & Dialogues Management

This document provides a comprehensive overview of the various screens and dialogues associated with our product, as well as the possible transitions between them.

## Table of Contents

1. [Introduction](#introduction)
2. [Screens](#screens)
3. [Dialogues](#dialogues)
4. [Flowchart](#flowchart)
5. [Updates & Revisions](#updates-revisions)

## Introduction

Understanding the architecture of our application's UI is crucial for both developers and stakeholders. This documentation serves as a guide to the screen and dialogues' names and their interactions. 

## Screens

- **Home**: Main screen from which users can navigate to various functionalities.
- **Add Quest**: This screen allows users to create a new quest. Upon entering this screen, users are presented with a form that prompts them to input the quest title, set a deadline, gold reward, and add a brief description. Upon filling in the necessary details, users can preview their quest and, once satisfied, can save it to their quest list. A confirmation dialogue appears once the quest is successfully added, and users then return to the Home screen where they can proceed to add another quest
- **Edit Quest**: The "Edit Quest" screen is designed for users who need to modify details of an existing quest. Upon accessing this screen, the system fetches and displays the current details of the selected quest. Users can then make adjustments to fields such as the quest name, duration, description, type, priority level, and assigned members or groups. As changes are made, a real-time preview reflects the modifications. An "Update" button is prominently placed for users to confirm their edits, while a "Discard Changes" option allows users to revert to the original quest details. Upon successfully updating the quest, a confirmation message appears, informing users of the applied changes and giving them the option to either edit another quest or navigate back to the Home screen.


## Dialogues
- **Add Name_Welcome**: This dialogue appears when a user opens the application for the first time. It prompts the user to optionally provide a nickname.
- **Add Name**: The "Add Name" dialogue emerges when a user intends to add a new nickname to the system (they shouldn't provide a nickname beforehand). After providing the necessary details, a simple "Add" button confirms the entry, while a "Cancel" option lets users exit without saving. Upon successful addition, a brief confirmation message is displayed.
- **Edit Name**: The "Edit Name" dialogue is activated when users wish to modify an existing name entry in the system. Within this dialogue, the current name details are pre-populated, allowing users to easily spot and make amendments. Fields for the first name, last name, and if applicable, middle name or initial, are present, along with any previously recorded nickname or title (e.g., Mr., Mrs., Dr.). Users can seamlessly make their desired changes and then confirm with an "Update" button. Should they change their mind or make an error, a "Reset" option reverts the fields to their original state. Additionally, a "Cancel" button allows exit without applying any changes. Upon successful modification, a notification confirms the name update.

## Flowchart

To visualize the transitions and interactions between screens and dialogues, refer to the flowchart below:

```mermaid
flowchart TD;
    A((Add Name_Welcome)) --> B(Home)
    B <--> C(Add Quest)
    B <--> D((Add Name))
    B <--> E((Edit Name))
    B <--> F(Edit Quest)
```


## Updates & Revisions

- **Version 1.0 (12 October 2023)**: Initial release of the documentation.


# Mermaid Chart is not supported by GitHub yet

```mermaid
flowchart TD;
    A((Add Name_Welcome)) -->|Add; Cancel| B(Home)
    B -->|Add Quest; Plus| C(Add Quest)
    C -->|Add Quest; Cancel| B
    B -->|Click here| D((Add Name))
    D --> |Ok; Cancel| B
    B -->|Edit Name| E((Edit Name))
    E --> |Ok; Cancel| B
    B -->|Tap on task on Home Screen| F(Edit Quest)
    F --> |Update Quest; Delete Quest; Cancel| B
```
[![](https://mermaid.ink/img/pako:eNqFUctqwzAQ_JVFJxmSH7ChkNgOvfRFUnoxFCGtY2M9gixRSpR_r2zHTiiU6iLt7MzsrvZMuBFIUlJL88UbZh0ciqzSEM-G0o0Q8MwUfn6g5EZhksB6_RAinEHONEcZYEsfh8yk2c55ePPYuwxepe8D5HSBrsT8N3GxuzfKZcs7aNBigOLWTnI1KQYShJfuD3kpWjcKApSULtEsL_-RH9gJjAbH-m64hzFhzy2iDrCb7O5H2k127yfBHM5jFSjxFi1lyIootIq1Iv79edBXxDWosCJpfAqsmZeuIpW-RCrzzuy_NSepsx5XxI8lipYdLVMkrZnsI4qxIWOfpn2Oa738AN6Kk6w?type=png)](https://mermaid.live/edit#pako:eNqFUctqwzAQ_JVFJxmSH7ChkNgOvfRFUnoxFCGtY2M9gixRSpR_r2zHTiiU6iLt7MzsrvZMuBFIUlJL88UbZh0ciqzSEM-G0o0Q8MwUfn6g5EZhksB6_RAinEHONEcZYEsfh8yk2c55ePPYuwxepe8D5HSBrsT8N3GxuzfKZcs7aNBigOLWTnI1KQYShJfuD3kpWjcKApSULtEsL_-RH9gJjAbH-m64hzFhzy2iDrCb7O5H2k127yfBHM5jFSjxFi1lyIootIq1Iv79edBXxDWosCJpfAqsmZeuIpW-RCrzzuy_NSepsx5XxI8lipYdLVMkrZnsI4qxIWOfpn2Oa738AN6Kk6w)