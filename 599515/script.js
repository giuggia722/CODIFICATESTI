function toggleMetadataSidebar() {
    const sidebar = document.getElementById('metadataSidebar');
    const metadataButton = document.querySelector('.metadata-button');
    sidebar.classList.toggle('open');
    metadataButton.classList.toggle('active');
}// script.js
document.addEventListener('DOMContentLoaded', () => {
    
    function handleZoneAndTextInteractions() {
        
        document.querySelectorAll('.text-line').forEach(line => {
            const zoneId = line.dataset.zone;
            if (!zoneId) return;
            
            line.addEventListener('mouseenter', () => {
                line.classList.add('active');
                document.querySelectorAll(`#zone-${zoneId}`).forEach(zone => {
                    if (zone) zone.classList.add('active');
                });
            });
            
            line.addEventListener('mouseleave', () => {
                line.classList.remove('active');
                document.querySelectorAll(`#zone-${zoneId}`).forEach(zone => {
                    if (zone) zone.classList.remove('active');
                });
            });
        });
    
        // Handle zone hover/click
        document.querySelectorAll('.highlight-zone').forEach(zone => {
            const zoneId = zone.id.replace('zone-', '');
            
            zone.addEventListener('mouseenter', () => {
                zone.classList.add('active');
                
                document.querySelectorAll(`.text-line[data-zone="${zoneId}"]`).forEach(line => {
                    line.classList.add('active');
                });
            });
            
            zone.addEventListener('mouseleave', () => {
                zone.classList.remove('active');
                
                document.querySelectorAll(`.text-line[data-zone="${zoneId}"]`).forEach(line => {
                    line.classList.remove('active');
                });
            });
        });
    
        // Click handling for persistent selection
        document.querySelectorAll('.text-line, .highlight-zone').forEach(element => {
            element.addEventListener('click', (e) => {
                e.stopPropagation();
                const isTextLine = element.classList.contains('text-line');
                
               
                document.querySelectorAll('.active').forEach(el => el.classList.remove('active'));
                
                if (isTextLine) {
                    
                    element.classList.add('active');
                    const zoneId = element.dataset.zone;
                    document.querySelectorAll(`#zone-${zoneId}`).forEach(zone => {
                        if (zone) zone.classList.add('active');
                    });
                } else {
                   
                    element.classList.add('active');
                    const zoneId = element.id.replace('zone-', '');
                    document.querySelectorAll(`.text-line[data-zone="${zoneId}"]`).forEach(line => {
                        line.classList.add('active');
                    });
                }
            });
        });
    
        // Clear selection
        document.body.addEventListener('click', (e) => {
            if (!e.target.closest('.text-line, .highlight-zone, .entity-controls')) {
                document.querySelectorAll('.active').forEach(el => el.classList.remove('active'));
            }
        });
    }
    
    // Initialize 
    document.addEventListener('DOMContentLoaded', () => {
        handleZoneAndTextInteractions();
        setupEntityControls();
    });
    
   

   
    function setupEntityControls() {
        const entityButtons = document.querySelectorAll('.entity-button');
        const activeEntities = new Set();

        entityButtons.forEach(button => {
            button.addEventListener('click', () => {
                const entityType = button.getAttribute('data-entity');
                
                
                button.classList.toggle('active');
                
                if (activeEntities.has(entityType)) {
                   
                    activeEntities.delete(entityType);
                    document.querySelectorAll(`[data-entity="${entityType}"]`)
                        .forEach(entity => entity.classList.remove('highlight'));
                } else {
                    
                    activeEntities.add(entityType);
                    document.querySelectorAll(`[data-entity="${entityType}"]`)
                        .forEach(entity => entity.classList.add('highlight'));
                }
            });
        });

       
        const clearAllButton = document.createElement('button');
        clearAllButton.className = 'entity-button clear-all';
        clearAllButton.textContent = 'Clear All';
        document.querySelector('.entity-controls').appendChild(clearAllButton);

        clearAllButton.addEventListener('click', () => {
            
            document.querySelectorAll('.entity').forEach(entity => {
                entity.classList.remove('highlight');
            });
            
            entityButtons.forEach(button => {
                button.classList.remove('active');
            });
            
            activeEntities.clear();
        });
    }

    
    handleZoneAndTextInteractions();
    setupEntityControls();

    
    document.body.addEventListener('click', (e) => {
        if (!e.target.closest('.text-line, .highlight-zone, .entity-controls')) {
            document.querySelectorAll('.active').forEach(el => el.classList.remove('active'));
        }
    });
});

document.addEventListener('DOMContentLoaded', () => {
    const sidebar = document.createElement('div');
    sidebar.className = 'term-sidebar';
    
    const termCategories = {
        theme: ['agriculture', 'labor', 'technology', 'historical', 'culture', 'nature', 
               'politics', 'social', 'economy', 'poverty', 'military', 'administration', 
               'linguistics', 'verismo', 'historical'],
        verbum: [],
        ethnic: [],
        role: []
    };

    // Create sidebar content with all categories
    sidebar.innerHTML = `
        <div class="term-sidebar-header">
            <h3>Term Categories</h3>
            <button class="close-sidebar">×</button>
        </div>
        <div class="sidebar-controls">
            <button class="select-all-btn">Select All</button>
            <button class="clear-all-btn">Clear All</button>
        </div>
        ${Object.entries(termCategories).map(([category, subcategories]) => `
            <div class="term-category">
                <div class="term-category-header">${category}</div>
                ${subcategories.length > 0 ? `
                    <div class="subcategory-list">
                        ${subcategories.map(sub => `
                            <div class="subcategory-item">
                                <input type="checkbox" 
                                       id="${category}-${sub}" 
                                       class="subcategory-checkbox" 
                                       data-category="${category}" 
                                       data-subcategory="${sub}">
                                <label for="${category}-${sub}" class="subcategory-label">${sub}</label>
                            </div>
                        `).join('')}
                    </div>
                ` : `
                    <div class="category-checkbox-container">
                        <input type="checkbox" 
                               id="${category}" 
                               class="category-checkbox" 
                               data-category="${category}">
                        <label for="${category}" class="category-label">All ${category}</label>
                    </div>
                `}
            </div>
        `).join('')}
    `;
    
    document.body.appendChild(sidebar);

   
    const termsButton = document.querySelector('.entity-button[data-entity="term"]');
    termsButton.addEventListener('click', (e) => {
        e.stopPropagation();
        sidebar.classList.toggle('open');
        termsButton.classList.toggle('active');
    });

    const closeButton = sidebar.querySelector('.close-sidebar');
    closeButton.addEventListener('click', () => {
        sidebar.classList.remove('open');
        termsButton.classList.remove('active');
    });

    const selectAllBtn = sidebar.querySelector('.select-all-btn');
    selectAllBtn.addEventListener('click', () => {
        sidebar.querySelectorAll('.subcategory-checkbox, .category-checkbox').forEach(checkbox => {
            checkbox.checked = true;
            const event = new Event('change');
            checkbox.dispatchEvent(event);
        });
    });

    const clearAllBtn = sidebar.querySelector('.clear-all-btn');
    clearAllBtn.addEventListener('click', () => {
        sidebar.querySelectorAll('.subcategory-checkbox, .category-checkbox').forEach(checkbox => {
            checkbox.checked = false;
            const event = new Event('change');
            checkbox.dispatchEvent(event);
        });
        document.querySelectorAll('.entity[data-entity="term"]').forEach(term => {
            term.classList.remove('highlight');
        });
    });

    // Handle subcategory selection
    sidebar.querySelectorAll('.subcategory-checkbox').forEach(checkbox => {
        checkbox.addEventListener('change', () => {
            const category = checkbox.dataset.category;
            const subcategory = checkbox.dataset.subcategory;
            
            document.querySelectorAll('.entity[data-entity="term"]').forEach(term => {
                if (term.dataset.type === category && term.dataset.subtype === subcategory) {
                    term.classList.toggle('highlight', checkbox.checked);
                }
            });
        });
    });

    // Handle category selection for categories without subcategories
    sidebar.querySelectorAll('.category-checkbox').forEach(checkbox => {
        checkbox.addEventListener('change', () => {
            const category = checkbox.dataset.category;
            
            document.querySelectorAll('.entity[data-entity="term"]').forEach(term => {
                if (term.dataset.type === category) {
                    term.classList.toggle('highlight', checkbox.checked);
                }
            });
        });
    });

    // Close sidebar when clicking outside
    document.addEventListener('click', (e) => {
        if (!sidebar.contains(e.target) && 
            !termsButton.contains(e.target) && 
            sidebar.classList.contains('open')) {
            sidebar.classList.remove('open');
            termsButton.classList.remove('active');
        }
    });
});
document.addEventListener('DOMContentLoaded', () => {
    // Create places sidebar
    const placesSidebar = document.createElement('div');
    placesSidebar.className = 'place-sidebar';
    
    const placeCategories = ['country', 'urban', 'natural', 'continent', 'administrative', 'region'];

    placesSidebar.innerHTML = `
        <div class="sidebar-header">
            <h3>Place Categories</h3>
            <button class="close-sidebar">×</button>
        </div>
        <div class="sidebar-controls">
            <button class="select-all-btn">Select All</button>
            <button class="clear-all-btn">Clear All</button>
        </div>
        <div class="categories-list">
            ${placeCategories.map(category => `
                <div class="category-item">
                    <input type="checkbox" 
                           id="place-${category}" 
                           class="category-checkbox" 
                           data-category="${category}">
                    <label for="place-${category}" class="category-label">${category}</label>
                </div>
            `).join('')}
        </div>
    `;
    
    document.body.appendChild(placesSidebar);

    
    const placesButton = document.querySelector('.entity-button[data-entity="place"]');
    placesButton.addEventListener('click', (e) => {
        e.stopPropagation();
        placesSidebar.classList.toggle('open');
        placesButton.classList.toggle('active');
    });

    
    const closeButton = placesSidebar.querySelector('.close-sidebar');
    closeButton.addEventListener('click', () => {
        placesSidebar.classList.remove('open');
        placesButton.classList.remove('active');
    });

    
    const selectAllBtn = placesSidebar.querySelector('.select-all-btn');
    selectAllBtn.addEventListener('click', () => {
        placesSidebar.querySelectorAll('.category-checkbox').forEach(checkbox => {
            checkbox.checked = true;
            const event = new Event('change');
            checkbox.dispatchEvent(event);
        });
    });

    
    const clearAllBtn = placesSidebar.querySelector('.clear-all-btn');
    clearAllBtn.addEventListener('click', () => {
        placesSidebar.querySelectorAll('.category-checkbox').forEach(checkbox => {
            checkbox.checked = false;
            const event = new Event('change');
            checkbox.dispatchEvent(event);
        });
        document.querySelectorAll('.entity[data-entity="place"]').forEach(place => {
            place.classList.remove('highlight');
        });
    });

    
    placesSidebar.querySelectorAll('.category-checkbox').forEach(checkbox => {
        checkbox.addEventListener('change', () => {
            const category = checkbox.dataset.category;
            
            document.querySelectorAll('.entity[data-entity="place"]').forEach(place => {
                if (place.dataset.type === category) {
                    place.classList.toggle('highlight', checkbox.checked);
                }
            });
        });
    });

    // Close sidebar when clicking outside
    document.addEventListener('click', (e) => {
        if (!placesSidebar.contains(e.target) && 
            !placesButton.contains(e.target) && 
            placesSidebar.classList.contains('open')) {
            placesSidebar.classList.remove('open');
            placesButton.classList.remove('active');
        }
    });
});
// Add page navigation buttons
function setupPageNavigation() {
    const pageButtonsContainer = document.querySelector('.page-buttons');
    const pages = document.querySelectorAll('.page-container');

    pages.forEach(page => {
        const pageNumber = page.id.replace('page-', '');
        const button = document.createElement('button');
        button.textContent = `Page ${pageNumber}`;
        button.addEventListener('click', () => {
            page.scrollIntoView({ behavior: 'smooth' });
        });
        pageButtonsContainer.appendChild(button);
    });
}





