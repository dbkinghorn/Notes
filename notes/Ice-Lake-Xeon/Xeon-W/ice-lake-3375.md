## Intel Xeon W 3375 vs AMD TR Pro 3995WX  Numpy (linalg)


<style>
  table.blogtable {
    width: 95%;
    font-size: 14px;
    font-family: Helvetica, Arial, sans-serif;
    border-collapse: collapse;
    table-layout: fixed;
    margin: 4px 0 ;
    border-bottom: 2px solid #333;
  }

  h3.tableheading {
    margin-bottom: 20px;
  }

  table.blogtable thead th {
    background: #333;
    color: #fff;
  }

  table.blogtable th,td {
    padding: 8px 4px;
  }

  table.blogtable thead th {
    text-align: left;
  }

  table.blogtable tbody th {
    text-align: left;
  }

  table.blogtable tbody tr {
    color: #333;
  }
  table.blogtable tbody tr:hover {
    color: #960;
  }

  table.blogtable tbody tr:nth-child( even ) {
    background: #eee;
  }

  table.blogtable tbody col:nth-child(1) {
    white-space: nowrap;
  }
  </style>

<table class="blogtable">
<thead>
<tr><th>CPU</th><th>Numpy Version</th><th>Matmul (GFLOPS) </th><th>F-Norm (GFLOPS)</th><th>Cholesky (GFLOPS)</th></tr>
</thead>
<tbody>
<tr><td>Xeon-W 3375  </td><td> Anaconda <br/> numpy-1.20.3 mkl-2021.3.0   </td><td> 2271 </td><td> 2251 </td><td> 902 </td></tr>
<tr><td>TR Pro 3995WX</td><td> Anaconda<br/>numpy-1.19.2 mkl-2020.2    </td><td>  501 </td><td>  484 </td><td> 401 </td></tr>

<tr><td>Xeon-W 3375  </td><td> Conda-Forge<br/>numpy-1.20.3  openblas-0.3.17</td><td>  348 </td><td>  346 </td><td> 235 </td></tr>
<tr><td>TR Pro 3995WX</td><td> Conda-Forge <br/>numpy-1.20.3  openblas-0.3.17</td><td> 1421 </td><td> 1415 </td><td> 522 </td></tr>

<tr><td>Xeon-W 3375  </td><td> Intel<br/>numpy-1.20.3  mkl-2021.3.0-intel       </td><td> 2267 </td><td> 2247 </td><td> 893 </td></tr>
<tr><td>TR Pro 3995WX</td><td> Intel <br/>numpy-1.20.3  mkl-2021.3.0-intel      </td><td> 1467 </td><td> 1459 </td><td> 933 </td></tr>

</tbody>
</table>

