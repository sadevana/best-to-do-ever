```mermaid
flowchart TD;
    A((Add Name_Welcome)) -->|Add; Cancel| B(Home Screen)
    B -->|Add Quest; Plus| C(Add Quest)
    C -->|Add Quest; Cancel| B
    B -->|Click here| D((Add Name))
    B -->|Edit Name| E((Edit Name))
    B -->|Tap on task on Home Screen| F(Edit Quest)
```
