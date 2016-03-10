Notebook
==============================


Enable python 2.7: 

```
scl enable python27 bash
```

Launch your own notebook

```
jupyter notebook --no-browser --ip=localhost --port=1234
```

Tunnel to your notebook

```
ssh -L1234:localhost:1234 pubgw1.daplab.ch 
```

<- mind adapting the port to what you have set before


Access your notebook

Open in your browser [http://localhost:1234](http://localhost:1234)

Bonus:

```
screen -S "somename"
```
