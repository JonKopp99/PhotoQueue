
# Photo Queue

Uses **Operations, GCD,** and **semaphores** to apply filters to images that it downloads from the internet.

## The Isssue

One of the main issues we run into while performing large tasks is that the entire UI of the app pauses. In order to fix this issue we must use Operations and Threads to smoothly run these tasks. In the project I used both **GCD** and **Operations** to get this job done. My tasks were two simple ones but also very common. 

The first task was to download an image from a URl and then place it inside a tableview cell. To get this first task done I used an opertation which would download the image. Once this operation was done I would then return to the main thread in order to update the UI with the completed Operation. 

The second task was a little trickier because it was a larger task then the previous. I first created an operation that would take a picture and then apply a filter to it. I used the same approach as I did previously and returned to the main thread when it was finished filtering to apply the filter to the image.

## Extras

Created a custom ActivityIndicator that will change its color in a very flashy and exciting way!

![](https://lh3.googleusercontent.com/l4jeiPVIkd_jumIsibyM3Ab2N52JH9i98mMluqkSQtzhbijy6PyDrlnZIpONoOCnJo-u0YZkEx_T)![](https://lh3.googleusercontent.com/dvbgQTcM7i2cZkK5RCjM9_T7xWecWrd_hfKZkdQI6UIajxszmf2dvBUk0YC9efPOdYSfzt0IULlM)
