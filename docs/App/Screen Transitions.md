
```mermaid
flowchart TD;
    A((Add Name_Welcome)) --> B(Home)
    B <--> C(Add Quest)
    B <--> D((Add Name))
    B <--> E((Edit Name))
    B <--> F(Edit Quest)
```



# Mermaid not supported by Github yet

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
