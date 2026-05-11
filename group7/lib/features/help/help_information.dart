const String helpJson = '''{
    "why": "This application helps you stay aware of the air you breathe every day. By tracking real-time air quality and pollution levels, it allows you to make safer and healthier choices for yourself, your family, and your daily activities. ",
    "pm2_5":{
        "description" : "PM2.5 is a particulate matter, where particles have an aerodynamic diameter equal to or less than 2.5 μm. ",
        "short_risk" : "Breathing in PM2.5 for short periods (up to a day) can irritate the lungs and heart. It may cause asthma attacks, coughing, breathing problems, and increase hospital visits, especially in children, older adults, and people with heart or lung conditions. ",
        "long_risk":"Long-term (months to years) exposure to PM2.5 has been linked to premature death, particularly in people who have chronic heart or lung diseases, and reduced lung function growth in children. ",
        "src":[
            "https://iris.who.int/server/api/core/bitstreams/551b515e-2a32-4e1a-a58c-cdaecd395b19/content",
            "https://ww2.arb.ca.gov/resources/inhalable-particulate-matter-and-health]"
        ]

    },
    
    "pm_10":{
        "description" : "PM10 is a particulate matter, where particles have an aerodynamic diameter equal to or less than 10 μm. ",
        "short_risk" : "Short-term exposures to PM10 have been associated primarily with worsening of respiratory diseases, including asthma and chronic obstructive pulmonary disease (COPD). ",
        "long_risk":   "The effects of long-term exposure to PM10 are less clear, although several studies suggest a link between long-term PM10 exposure and respiratory mortality. ",
        
        "src":[
            "https://iris.who.int/server/api/core/bitstreams/551b515e-2a32-4e1a-a58c-cdaecd395b19/content",
            "https://ww2.arb.ca.gov/resources/inhalable-particulate-matter-and-health]"
        ]

    },

    "un" : 
        {
            
            "goal3" : "The United Nations Sustainable Development Goal (SDG) 3 focuses on ensuring healthy lives and promoting well-being for people of all ages. This application supports SDG 3: Good Health and Well-Being by helping reduce health risks caused by air pollution through real-time air quality monitoring and increased public awareness of harmful particles in the air. ",
            "goal11" : "UN:s SDG 11 focuses on making cities and communities safer, more sustainable, and environmentally friendly. This application contributes to SDG 11: Sustainable Cities and Communities by encouraging cleaner and safer urban environments through environmental monitoring, pollution tracking, and access to reliable air quality data. "
        }
    
}''';