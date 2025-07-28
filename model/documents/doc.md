## Compiling

#### Installing all dependencies (except Python)
```brew install cmake ninja git boost eigen ccache```

Optionally install ```paraview```
```brew install --cask paraview```

#### Cloning git Repo
```git clone https://github.com/ufz/ogs.git```
```cd ogs```

#### Configure CMake
```mkdir build```
```cd build```
```cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release```

#### Compile the Code
```ninja```

#### OGS Run
```./bin/ogs ../Tests/Data/Elliptic/1D/1d_square_1e0.prj```

#### Test
```ctest```
NB: The executable file is in ```build/bin/ogs```
