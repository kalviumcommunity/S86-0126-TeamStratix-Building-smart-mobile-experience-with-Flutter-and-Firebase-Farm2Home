# Google Maps Integration Demo - Video Script

**Duration**: 8-10 minutes  
**Platform**: Google Drive (with edit access)  
**Format**: MP4 (1080p recommended)

---

## 📹 Pre-Recording Checklist

- [ ] Device fully charged
- [ ] Good lighting setup (no shadows on face)
- [ ] Quiet background
- [ ] Microphone tested
- [ ] App tested thoroughly
- [ ] All features working
- [ ] Code ready to show
- [ ] Face visible on camera (top-right recommended)
- [ ] Screen recording tool ready

---

## 🎬 Detailed Script with Timings

### **INTRO (0:00 - 0:30) - 30 seconds**

**Face on camera, speak clearly**:

> "Hi! I'm demonstrating the Google Maps SDK integration for the Farm2Home Flutter application. In this video, I'll show you how we've successfully integrated Google Maps with full platform configuration for both Android and iOS, complete with interactive markers and real-time map navigation.
>
> Our Farm2Home platform uses this map to display three key locations: our central hub in San Francisco, our partner farms in Sacramento, and our distribution market in San Jose. Let me show you how it works."

**Visual**: Show yourself briefly, establish credibility

---

### **SECTION 1: App Navigation (0:30 - 1:30) - 1 minute**

**Narration**:

> "Let's start by opening the Farm2Home application. I'm starting from the home screen where you can see the main menu."

**Actions**:
1. Show home screen with menu items
2. Scroll down to find "Location Preview"
3. Point to the menu item

**Narration**:

> "Here's our 'Location Preview' option with a maps icon. This is where our Google Maps integration lives. Let me tap on it to navigate to the map screen."

**Actions**:
1. Tap the Location Preview menu item
2. Wait for map to load (2-3 seconds)
3. Let it fully render

**Narration**:

> "And there we go! The Google Map is loading. Notice the map is rendering with proper styling and our three location markers are clearly visible."

---

### **SECTION 2: Map Overview & Features (1:30 - 3:00) - 1.5 minutes**

**Show the full map with all markers visible**

**Narration**:

> "Here's our interactive map display. The map shows three important locations for Farm2Home:

> **[Point to green marker]** The green marker represents our main hub in San Francisco - that's where we coordinate all operations.

> **[Point to orange marker]** The orange marker shows our partner farm in Sacramento - where we source our fresh produce.

> **[Point to red marker]** And the red marker indicates our distribution market in San Jose - where customers can pickup their orders.

> The map is fully interactive. You can zoom, pan, and tap on markers to see location information. The zoom controls are visible here [point], along with the compass and my-location button."

**Actions**:
1. Show the full map with all three markers
2. Point to the controls
3. Show the information cards below the map

---

### **SECTION 3: Interactive Testing - Zoom (3:00 - 4:00) - 1 minute**

**Narration**:

> "Let's demonstrate the interactive features. First, I'll show you the pinch-zoom capability. By pinching with two fingers, I can smoothly zoom in and out."

**Actions**:
1. Pinch zoom in toward San Francisco
2. Count to 3 while zoomed in
3. Pinch zoom back out
4. Repeat once more

**Narration**:

> "As you can see, the map zooms smoothly and the markers scale appropriately. I can also use the zoom controls [point and tap +] to incrementally zoom, or [tap -] to zoom back out."

**Actions**:
1. Tap the + button to zoom in
2. Tap the - button to zoom out

---

### **SECTION 4: Interactive Testing - Pan & Drag (4:00 - 5:00) - 1 minute**

**Narration**:

> "The map is fully draggable. By touching and dragging with one finger, I can pan around the map to view different areas."

**Actions**:
1. Drag the map left
2. Drag the map right
3. Drag the map up
4. Drag the map down
5. End by panning back to center all three markers

**Narration**:

> "The map responds smoothly to panning gestures. Now let me show you what happens when we tap on a marker."

---

### **SECTION 5: Marker Interaction (5:00 - 6:00) - 1 minute**

**Narration**:

> "When I tap on a marker, an info window pops up showing the location name. Let me tap on each location to demonstrate."

**Actions**:
1. Tap the green marker
2. Wait for info window (should show "Farm2Home Hub")
3. Tap elsewhere to close
4. Tap orange marker
5. Show info window (should show location name)
6. Tap elsewhere to close
7. Tap red marker
8. Show info window

**Narration**:

> "As you see, each marker displays helpful information about the location. The info windows are interactive and properly positioned over the markers."

---

### **SECTION 6: Navigation Buttons (6:00 - 7:00) - 1 minute**

**Narration**:

> "Below the map, you'll notice our navigation shortcuts. These orange buttons allow quick navigation to each location."

**Actions**:
1. Scroll down to show the navigation buttons
2. Click "Navigate to Hub"
3. Show the animation to San Francisco (wait 2 seconds)
4. Click "Navigate to Farm"
5. Show the animation to Sacramento
6. Click "Navigate to Market"
7. Show the animation to San Jose
8. Click "Reset to Default"
9. Show animation back to starting view with all three markers

**Narration**:

> "These navigation buttons provide smooth camera animations to each location. Users can quickly jump between the three key areas of our Farm2Home network. The map centered back to the starting position with all three markers visible."

---

### **SECTION 7: Code Explanation (7:00 - 8:30) - 1.5 minutes**

**Show code section in the app, or switch to code editor**

**Narration**:

> "Now let me show you the code that powers this implementation. The LocationPreviewScreen uses Google's GoogleMap widget with the following key features:

> **[Point to code or describe]** We initialize the GoogleMap with an initial camera position set to San Francisco at zoom level 10. The markers are created from our LatLng coordinates for each location.

> The GoogleMap configuration includes zoom controls, compass, my-location button, and building rendering for better visual context."

**Actions**:
1. Scroll through the code explanation in the app
2. Show the GoogleMap widget configuration
3. Point out key properties: initialCameraPosition, markers, onMapCreated
4. Show the marker creation code

**Narration**:

> "We create three markers with custom colors:
> - Green for the hub
> - Orange for the farm  
> - Red for the market

> Each marker includes custom info windows that display when tapped. The camera animation is handled through the GoogleMapController which provides smooth, professional transitions between locations."

---

### **SECTION 8: Platform Configuration (8:30 - 9:00) - 30 seconds**

**Show configuration files (blur sensitive data)**

**Narration**:

> "To make this work on both Android and iOS, we need platform-specific configuration:

> **For Android**: We add the Google Maps API key to the AndroidManifest.xml file. [Show the meta-data tag - blur the actual API key value]

> **For iOS**: We configure the Info.plist file with the API key and set the embedded views preview flag. [Show the plist configuration - blur the actual API key value]

> Both platforms require proper API key setup in Google Cloud Console, and we've configured appropriate permissions for internet and location access on both platforms."

**Actions**:
1. Show AndroidManifest.xml (blur API key with hand or emoji)
2. Show Info.plist (blur API key)
3. Keep talking about configuration

---

### **SECTION 9: Summary & Closing (9:00 - 10:00) - 1 minute**

**Face on camera again**

**Narration**:

> "To summarize, we've successfully integrated Google Maps into Farm2Home with:

> ✅ Full Android and iOS platform configuration  
> ✅ Three interactive location markers  
> ✅ Smooth zoom and pan controls  
> ✅ Camera animation to locations  
> ✅ Marker info windows  
> ✅ Professional UI with code examples and configuration reference  
> ✅ Responsive design that works on all screen sizes  

> The map is fully functional, interactive, and ready for production. Users can explore the Farm2Home network locations with an intuitive, touch-responsive experience.

> This implementation demonstrates competency with platform-specific configuration, widget integration, state management, and user interaction handling in Flutter.

> Thanks for watching! All code has been committed to GitHub and is ready for review."

**Actions**:
1. Look at camera
2. Smile/nod
3. End on positive note

---

## 🎥 Technical Recording Tips

### Camera Setup
- Position face in top-right corner of screen
- Use good lighting (natural light or ring light)
- Position camera above eye level slightly
- Frame should show face and entire screen

### Screen Recording
- Record at 1080p or higher
- Use screen capture software (OBS, QuickTime on Mac, Windows 10 built-in, etc.)
- Show cursor for interactions
- Slow down actions slightly for visibility (2-3 second pauses)

### Audio
- Use external microphone if available
- Speak clearly and slowly
- Avoid background noise
- Use steady pacing (not too fast, not too slow)
- Do multiple takes if needed

### Performance
- Close unnecessary apps before recording
- Ensure good device performance
- Test map rendering before starting
- Have backup plan if app crashes

---

## 📝 Post-Recording Steps

1. **Review**: Watch entire video for:
   - All features shown clearly
   - Audio is clear and understandable
   - Video is well-paced
   - No sensitive information visible (API keys)
   - Professional appearance

2. **Edit** (optional):
   - Trim beginning/end
   - Speed up pauses if too long
   - Add title slide
   - Add transitions if desired
   - Boost audio if needed

3. **Export**:
   - Format: MP4
   - Resolution: 1080p
   - Codec: H.264
   - Audio: AAC 128kbps

4. **Upload to Google Drive**:
   - Create folder: "Farm2Home - Google Maps Demo"
   - Upload video
   - Set permissions: "Anyone with link can view"
   - Generate shareable link
   - Add to GitHub PR description

---

## 📊 Script Timing Reference

| Section | Time | Duration |
|---------|------|----------|
| Intro | 0:00-0:30 | 30 sec |
| App Navigation | 0:30-1:30 | 1 min |
| Map Overview | 1:30-3:00 | 1.5 min |
| Zoom Demo | 3:00-4:00 | 1 min |
| Pan/Drag Demo | 4:00-5:00 | 1 min |
| Marker Tapping | 5:00-6:00 | 1 min |
| Navigation Buttons | 6:00-7:00 | 1 min |
| Code Explanation | 7:00-8:30 | 1.5 min |
| Configuration | 8:30-9:00 | 30 sec |
| Summary/Closing | 9:00-10:00 | 1 min |
| **TOTAL** | **0:00-10:00** | **~10 min** |

---

## ✅ Quality Checklist

- [ ] Video is 8-10 minutes
- [ ] Audio is clear (no background noise)
- [ ] Face is visible on camera
- [ ] All features demonstrated
- [ ] Map renders clearly
- [ ] Zoom/pan smooth
- [ ] Markers tappable
- [ ] Navigation buttons work
- [ ] Code shown clearly
- [ ] Configuration explained
- [ ] No API keys visible
- [ ] Professional appearance
- [ ] Well-paced (not too fast)
- [ ] Logical flow
- [ ] Engaging presentation

---

## 🚫 Things to Avoid

❌ Showing actual API keys  
❌ Rushing through features  
❌ Mumbling or unclear speech  
❌ Static screen (no face)  
❌ Poor lighting  
❌ Background noise  
❌ Too many cuts/transitions  
❌ Skipping features  
❌ Technical jargon without explanation  
❌ Playing music (unless specifically required)  

---

## 📤 Submission

**After Recording & Uploading**:

1. Get Google Drive link (shareable, view access)
2. Paste link in GitHub PR description
3. Add video timestamp notes if helpful
4. Include "See demo video at: [link]"
5. Verify link works before submitting

---

**Script Written**: February 6, 2026  
**Ready for Recording**: ✅ Yes  
**Estimated Recording Time**: 15-20 minutes (including retakes)  
**Final Video Target**: 8-10 minutes duration
