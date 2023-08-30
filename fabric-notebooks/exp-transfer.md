::: {.cell .markdown}
### Transfer experiment data
:::

::: {.cell .code}
```python
tx_node.execute('tar -czf ' + data_dir + '.tgz ' + data_dir)
```
:::

::: {.cell .code}
```python
tx_node.download_file(data_dir + '.tgz', '/home/ubuntu/' + data_dir + '.tgz')
```
:::