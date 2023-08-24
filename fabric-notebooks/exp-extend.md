::: {.cell .markdown}
### Extend slice for one week
:::


::: {.cell .code}
```python
from datetime import datetime
from datetime import timezone
from datetime import timedelta

# Set end date to 7 days from now
end_date = (datetime.now(timezone.utc) + timedelta(days=7)).strftime("%Y-%m-%d %H:%M:%S %z")
slice.renew(end_date)
```
:::


::: {.cell .code}
```python
slice.update()
_ = slice.show()
```
:::
