Notebook
==============================


## Enable python 2.7: 

```
scl enable python27 bash
```

## Launch your own notebook

```
jupyter notebook --no-browser --ip=localhost --port=1234
```

## Tunnel to your notebook

```
ssh -L1234:localhost:1234 pubgw1.daplab.ch 
```

Mind adapting the port to what you have set before, since only one user can use the same port.
{: .vscc-notify-info }


## Access your notebook

Open in your browser [http://localhost:1234](http://localhost:1234)


## Bonus

Run your notebook in a [screen]() to make it resilient to network
failures (i.e. your notebook won't be killed if you disconnect from ssh)

```
screen -S "jupyter"
```

See the [screen manual] for more details on how to use `screen`.

If you find cool writing such piece of software, join us every Thursday evening for our weekly [Hacky Thursdays](http://daplab.ch/#hacky)!
{: .vscc-notify-info }
