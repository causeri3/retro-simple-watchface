# Garmin Watch Face: [Hal-6000](https://apps.garmin.com/en-US/apps/46e9c768-4eb1-470c-93a8-29dd11219b61) 


<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/7c6ec408-9f7b-4fbd-93ba-6ed820a9935c" width="200"/></td>
    <td><em>HAL 9000</em> from 2001: A Space Odyssey. Minimalistic Sci-Fi watch face with rounded writing. Completly operational and all circuits are functioning perfectly.
        HAL gets gets animated once your stress levels reach above 50%.</td>
  </tr>
</table>



---
<img src="https://github.com/user-attachments/assets/c79612de-1ab9-46d0-bc3d-2fb17d6307dc" width="900"/>

<img src="https://github.com/user-attachments/assets/339cca41-178c-4579-9ce1-dcf499dd237b" width="900"/>



https://github.com/user-attachments/assets/80156576-78e5-411a-927e-0950d5551592


---
### Settings

---

There are four fields you can change the settings for:

|               | Smoke | Bubble | Cup | Body | Battery Icon |
|------------------------|-----|------|---|-----------------|---|
| This is fine           | ✓    | ✓     |     |                   |
| Date                   | ✓    | ✓     |     |                   |
| Time                   | ✓    | ✓     |     |                   |
| Active Minutes         | ✓    | ✓     |     |                   |
| Steps               | ✓    | ✓     |     |                   |
| Calories               | ✓    | ✓     |     |                   |
| Stress Levels          | ✓    | ✓     | ✓  | ✓                 |   |
| Body Battery           | ✓    | ✓     | ✓  | ✓                 | ✓  |
| % Calorie Goal         | ✓    | ✓     | ✓  | ✓                 | ✓  |
| % Steps Goal         | ✓    | ✓     | ✓  | ✓                | ✓  |
| Battery Level         | ✓    | ✓     | ✓  | ✓                 | ✓  |
| Heart Rate             | ✓    | ✓     |✓   | ✓               |
| None                   | ✓    | ✓     | ✓  | ✓                |

You can also:
* choose your low stress picture
* turn the animation off
* set the threshold for the stress level animation
* set your calorie goal
* set your steps goal
* turn showing the battery icon off



## Set-up
### Installations

- [Garmin Connect IQ SDK](https://developer.garmin.com/connect-iq/reference-guides/monkey-c-command-line-setup/) - follow the steps in the link for your operating system
- *VS Code* or *Curser* with the *Monkey C Extension*
- [Java Development Kit (JDK)](https://www.oracle.com/java/technologies/javase-downloads.html)



### Build & Run
---
* Set-up variables

    Fill in your set-up variables in `properties.mk`

* Build with debug logs
   ```sh
   make build
   ```
* Run on simulator
   ```sh
   make run.settings
   ```
* Build for device
   ```sh
   make build.release
   ```
* Deploy on device
    1. Enable *Developer Mode* on your Garmin watch. 
    2. Copy the compiled `.prg` file from the `bin` into the `/GARMIN/APPS/` directory on your watch. (For Mac I used [Android File Transfer](https://android.p2hp.com/filetransfer/index.html))


If you want to test the settings on your comupter you can go in the Simulator either
* Trigger App Settings & click on the buttons in the simulator
or
* File > Edit Persistent Storage > Edit Application.Properties data


---

Contributions are more than welcome, if you give me time to test them, I might release it and publish to Connect IQ.

---

#### License
This project is licensed under GPLv3
