# Product Documentation: Screen & Dialogues Management

This document provides a comprehensive overview of the various screens and dialogues associated with our product, as well as the possible transitions between them.

## Table of Contents

1. [Introduction](#introduction)
2. [Screens](#screens)
   - [Home Screen](#home-screen)
     - [Interface Logic](#interface-logic)
       - [User Information Display](#user-information-display)
       - [To-Do List](#to-do-list)
       - [The Girl](#the-girl)
     - [Basic Task Card](#basic-task-card)
       - [Appearance & Logic](#appearance--logic)
       - [How User Enters](#how-user-enters)
   - [Add Quest](#add-quest)
     - [Interface Behavior](#interface-behavior)
     - [How User Enters](#how-user-enters-1)
3. [Dialogues](#dialogues)
4. [Alerts](#alerts)
5. [Flowchart](#flowchart)
6. [Updates & Revisions](#updates--revisions)


## Introduction

Understanding the architecture of our application's UI is crucial for both developers and stakeholders. This documentation serves as a guide to the screen and dialogues' names and their interactions. 

## Screens

- **Home**: Main screen from which users can navigate to various functionalities.
- **Add Quest**: This screen allows users to create a new quest. Upon entering this screen, users are presented with a form that prompts them to input the quest title, set a deadline, gold reward, and add a brief description. Upon filling in the necessary details, users can preview their quest and, once satisfied, can save it to their quest list. A confirmation dialogue appears once the quest is successfully added, and users then return to the Home screen where they can proceed to add another quest
- **Edit Quest**: The "Edit Quest" screen is designed for users who need to modify the details of an existing quest. Upon accessing this screen, the system fetches and displays the current details of the selected quest. Users can then make adjustments to fields such as the quest name, duration, description, type, priority level, and assigned members or groups. As changes are made, a real-time preview reflects the modifications. An "Update" button is prominently placed for users to confirm their edits, while a "Discard Changes" option allows users to revert to the original quest details. Upon successfully updating the quest, a confirmation message appears, informing users of the applied changes and giving them the option to either edit another quest or navigate back to the Home screen.

### Home Screen
Conceived in https://github.com/sadevana/best-to-do-ever/issues/6, https://github.com/sadevana/best-to-do-ever/issues/7, https://github.com/sadevana/best-to-do-ever/issues/5
A space should be added at the end of the quest list to allow for additional scrolling.
The space should be sufficient to ensure that the character (girl) does not obstruct the view of the last quest item when scrolling to the bottom.

#### Interface logic
Home screen consists of three big parts:

- user information
- to-do list
- girl

##### In user information display:
Username ([User: name ])
Total number of gold [Loot: Gold]
Reason: Keep these elements on the home screen as [50%+ of poll respondents](https://docs.google.com/forms/d/1l4sprV8_q2sV81gQAS7dqr3IcwKGncUN08uGSqbApcU/edit#responses) suggested

After updating the nickname, the new nickname should be displayed immediately without any lag or refresh. https://github.com/sadevana/best-to-do-ever/issues/32
After completing a task that rewards gold, the gold count should immediately update to reflect the earned amount. https://github.com/sadevana/best-to-do-ever/issues/32

##### To-do list
the To-do list consists of 7 sections:

- Overdue
- Today
- This week
- Next 30 days
- Later
- No date
- Done

in each section, task cards are displayed.
More on cards: #6 
cards are sorted by date-time starting from nearest to furthest 

A task should move to the 'Overdue' section after its due_date is past.
Now "end of the day" = 23:59, now it's constant. 
But it’s better to add the “end_of_the_day” variable into the logic now so you can quickly complete the creative end of the day later.

- **Today** ends at the end of the day.
- **Overdue** can be checked every minute, and when time.now > deadline, it is overdue
- **This week** ends at the end of the following Sunday.
- **Next 30 days** is earlier than time.now + 30 days
- **Later** is later than time.now + 30 days
- **No date** is an empty deadline field AND not Done
- **Done** is Done. 

##### The Girl
Option to Add quest opens 'Add Quest' Screen

#### How user enters
It's the main application screen

#### Basic task card
#### Basic task card: Appearance & Logic
The "tick" button should change its appearance based on task completion ([Task: done])
When the "tick" button is pressed task should change its done status to the opposite: done-> undone; undone -> done.

time\date ([Task:due date]) is displayed
time is HH:mm format
date is in DD.MM format
More on it in #

Add gold to ([Loot: total_gold]) for completing a task.
Gold awarded based on ([Task:Reward:Gold]) field
Deduct gold from ([Loot: total_gold]) for uncompleting a task
Total gold ([Loot: total_gold]) amount displayed on the home screen should be updated accordingly
NB: I am aware that in the future users can go negative with deductions. We will think about it in time

If the user taps the card, the Edit task screen opens.

When creating a task without a specified time, the task should: Not display any time, indicating that it doesn't have a specific due time.

#### Basic task card: How user enters
The user sees task cards on the Home screen

### Add Quest
Conceived in https://github.com/sadevana/best-to-do-ever/issues/4
#### Interface behavior
Only the task name is not nullable
The date is nullable, but if a user opens the date picker, the default is today.
The date is DD.MM.YY format
Time is nullable, but if a user opens the time picker, the default is 23:59.
Time is HH:mm format
Gold default is 5
Gold accepts int from 0 to 9 999 999 999
OK button saves tasks (adds new or saves changes)
The Cancel button closes the screen without saving changes
Users can cancel adding tasks by using the standard iOS button "Back"
Title field is obligatory and can't be empty https://github.com/sadevana/best-to-do-ever/issues/19
The Date field should only accept valid date formats and not allow letter characters.
The Time field should only accept valid time formats and reject letter characters.
The Gold field should only accept numeric values, it should not accept letter characters.
Max Gold: 9 999 999 999 https://github.com/sadevana/best-to-do-ever/issues/16

#### How user enters
A user enters the screen by choosing option in dialogue with a girl

## Dialogues
- **Add Name_Welcome**: This dialogue appears when a user opens the application for the first time. It prompts the user to optionally provide a nickname.
- **Add Name**: The "Add Name" dialogue emerges when a user intends to add a new nickname to the system (they shouldn't provide a nickname beforehand). After providing the necessary details, a simple "Add" button confirms the entry, while a "Cancel" option lets users exit without saving. Upon successful addition, a brief confirmation message is displayed.
- **Edit Name**: The "Edit Name" dialogue is activated when users wish to modify an existing name entry in the system. Within this dialogue, the current name details are pre-populated, allowing users to easily spot and make amendments. Fields for the first name, last name, and if applicable, middle name or initial, are present, along with any previously recorded nickname or title (e.g., Mr., Mrs., Dr.). Users can seamlessly make their desired changes and then confirm with an "Update" button. Should they change their mind or make an error, a "Reset" option reverts the fields to their original state. Additionally, a "Cancel" button allows exit without applying any changes. Upon successful modification, a notification confirms the name update.
- 
## Alerts
All alerts appear on the screen 3 seconds
An alert when adding a new task: `'✅ Successfully added quest'` | `'❌ Failed to add quest'`
An alert when completing \ incompleting the quest (will be changed next release): `'🎉 Hooray! Here's {task_gold_amount} gold'` | `'😭 Buuu! I take {task_gold_amount} gold back'` | `'❌ Failed to complete quest'` | `'❌ Failed to undo quest completion'`
![Image](https://github.com/sadevana/best-to-do-ever/assets/10058916/559917ab-fb72-428e-8a0b-5eca68c9f54f)

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
