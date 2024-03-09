# UnityShaders
# Phong Improved Shader with Cube Mapping

This repository contains an improved Phong shader implemented in Unity's High-Level Shader Language (HLSL) with added cube mapping for realistic reflections. This shader can be used to render materials with realistic lighting effects, including diffuse, specular, and reflective components.
This is done through the help of the https://www.youtube.com/watch?v=mL8U8tIiRRg , on writing shader codes for the Phong model ;
## Overview

The Phong Improved Shader is an unlit shader designed to simulate the Phong reflection model, which consists of ambient, diffuse, and specular lighting components. The shader calculates the lighting interaction between a surface and a light source to create realistic shading effects. Additionally, cube mapping is incorporated to achieve accurate reflections based on the surface's normal and view direction.

![Screenshot (2782)](https://github.com/Alireza-Khatami/UnityShaders/assets/78407392/dceb2dc5-36a7-4f05-9ee3-2872ede2ad62)


## Parameters

- **_MainTex**: Texture used for diffuse color.
- **_Gloss**: Glossiness factor controlling the intensity of specular highlights.
- **_CubeMap**: Cube map texture used for environment reflections.
- **- _Fresnel : fresnel factor controlling the amount of fresnel( highlighted outlines) 

## Usage

To use the Phong Improved Shader in your Unity project:

1. Copy the shader code into a new shader file in your project.
2. Create a material and assign the shader to it.
3. Set the appropriate textures and parameters, such as _MainTex, _Gloss, and _CubeMap.
4. Apply the material to your game objects to see the shader effects in action.

## Examples

You can find example scenes demonstrating the usage of the Phong Improved Shader with Cube Mapping in the "Scene" folder of this repository.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request.




