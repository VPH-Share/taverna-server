## Taverna Server v2.4.1 Setup

### Dependencies

 - Ubuntu 12.04 LTS

You can install the following tools via the command line with `curl`, `wget` or `git`.

 1. unzip
 2. git
 3. openjdk-7-jre-headless
 4. [Java Cryptography Extensions](http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html)
 5. tomcat6
 6. [atomhopper-1.2.9.war](http://maven.research.rackspacecloud.com/content/repositories/releases/org/atomhopper/atomhopper/1.2.9/atomhopper-1.2.9.war)
 7. [TavernaServer.2.4.1.war](https://launchpad.net/taverna-server/2.x/2.4.1/+download/TavernaServer.2.4.1.war)


### via `curl`

```Shell
curl -L https://raw.github.com/VPH-Share/taverna-server/master/install.sh | sh
```

### via `wget`

```Shell
wget --no-check-certificate https://raw.github.com/VPH-Share/taverna-server/master/install.sh -O - | sh
```

### via `git`

```Shell
git clone https://github.com/VPH-Share/taverna-server.git
cd taverna-server
./bootstrap.sh 2>&1 | tee ~/taverna-install.log
```

#### Firewall Configuration

To be able to access the the server from external clients, certain port redirections and service endpoints need to be configured.

##### Security Groups (VPH-Share Port Redirections)

<table>
<thead>
<tr>
<th>Name    </th>
<th> Type </th>
<th> Port </th>
<th> Source    </th>
<th> Notes </th>
</tr>
</thead>
<tbody>
<tr>
<td>taverna </td>
<td> TCP  </td>
<td> 1099 </td>
<td> 0.0.0.0/0 </td>
<td>       </td>
</tr>
<tr>
<td>web     </td>
<td> TCP  </td>
<td> 8080 </td>
<td> 0.0.0.0/0 </td>
<td> For VPH-Share use <strong>HTTP</strong> type</td>
</tr>
</tbody>
</table>

##### VPH-Share Endpoints

<table>
<thead>
<tr>
<th>Type         </th>
<th> Invocation Path       </th>
<th> Port      </th>
<th> WS/REST Descriptor</th>
</tr>
</thead>
<tbody>
<tr>
<td>webapp       </td>
<td> /taverna-server       </td>
<td> web(8080) </td>
<td></td>
</tr>
<tr>
<td>soap         </td>
<td> /taverna-server/soap  </td>
<td> web(8080) </td>
<td> /taverna-server/soap?wsdl</td>
</tr>
<tr>
<td>rest         </td>
<td> /taverna-server/rest  </td>
<td> web(8080) </td>
<td> /taverna-server/rest?_wadl</td>
</tr>
<tr>
<td>admin(rest)  </td>
<td> /taverna-server/admin </td>
<td> web(8080) </td>
<td> /taverna-server/admin?_wadl</td>
</tr>
</tbody>
</table>

**Note:** Ensure you insert the `WSDL` and `WADL` as a text string into the optional **WS/REST Descriptor** fields.


## Taverna Server Usage

The Taverna Server is now installed without SSL security and the following endpoints are available for use:

### Endpoint URIs

The various endpoints that Taverna Server presents will, of course, depend on what the DNS entry of your instance is but they all have a common root and by default use port 8080. Using taverna.example.org as an example server name the following endpoints are provided:

<table>
<thead>
<tr>
<th align="left">Endpoint                         </th>
<th align="left"> URI                                                        </th>
</tr>
</thead>
<tbody>
<tr>
<td align="left">Tomcat root                       </td>
<td align="left"> http://taverna.example.org:8080                            </td>
</tr>
<tr>
<td align="left">Taverna Server root               </td>
<td align="left"> http://taverna.example.org:8080/taverna-server             </td>
</tr>
<tr>
<td align="left">Taverna Server services           </td>
<td align="left"> http://taverna.example.org:8080/taverna-server/services    </td>
</tr>
<tr>
<td align="left">Taverna Server SOAP               </td>
<td align="left"> http://taverna.example.org:8080/taverna-server/soap        </td>
</tr>
<tr>
<td align="left">Taverna Server SOAP (WSDL)       </td>
<td align="left"> http://taverna.example.org:8080/taverna-server/soap?wsdl   </td>
</tr>
<tr>
<td align="left">Taverna Server REST               </td>
<td align="left"> http://taverna.example.org:8080/taverna-server/rest        </td>
</tr>
<tr>
<td align="left">Taverna Server REST (WADL)        </td>
<td align="left"> http://taverna.example.org:8080/taverna-server/rest?_wadl  </td>
</tr>
<tr>
<td align="left">Taverna Server admin REST         </td>
<td align="left"> http://taverna.example.org:8080/taverna-server/admin       </td>
</tr>
<tr>
<td align="left">Taverna Server admin REST (WADL) </td>
<td align="left">  http://taverna.example.org:8080/taverna-server/admin?_wadl </td>
</tr>
</tbody>
</table>

### Username and Password

There is a default user set up:

<table>
<thead>
<tr>
<th align="left">Username </th>
<th align="left"> Password </th>
</tr>
</thead>
<tbody>
<tr>
<td align="left">taverna  </td>
<td align="left"> taverna  </td>
</tr>
</tbody>
</table>

This user is both a regular taverna user and an administrator user. For details about these user types, how to change the password and how to set up more users please see the [Taverna Server installation and configuration documentation](http://dev.mygrid.org.uk/wiki/display/taverna/Installation+and+Configuration).
