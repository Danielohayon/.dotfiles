

# Lovely Tensors
numbers # torch.Tensor => tensor[3, 196, 196] n=115248 (0.4Mb) x∈[-2.118, 2.640] μ=-0.388 σ=1.073
numbers[1,:6,1] # Still shows values if there are not too many. => tensor[6] x∈[-0.443, -0.197] μ=-0.311 σ=0.091 [-0.197, -0.232, -0.285, -0.373, -0.443, -0.338]
(numbers+3).plt
(numbers+3).plt(center="mean", max_s=1000)
`pip install lovely-tensors`

``` python
import lovely_tensors as lt
lt.monkey_patch()
```
