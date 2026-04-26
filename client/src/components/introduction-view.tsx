import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "@/components/ui/collapsible";
import { Badge } from "@/components/ui/badge";
import { ChevronDown, ChevronRight, Heart, Zap, Clock, Activity, Dumbbell, Info, Settings, Flame, Snowflake, Footprints, Target, Move, PersonStanding } from "lucide-react";
import type { IntroSection } from "@shared/schema";
import { cn } from "@/lib/utils";

interface IntroductionViewProps {
  sections: IntroSection[];
  hideHeader?: boolean;
}

const iconMap: Record<string, typeof Heart> = {
  Settings,
  Flame,
  Snowflake,
  Heart,
  Activity,
  Footprints,
  Zap,
  Clock,
  Dumbbell,
  Info,
  Target,
  Move,
  PersonStanding,
};

function getIconComponent(iconName?: string) {
  if (iconName && iconMap[iconName]) {
    return iconMap[iconName];
  }
  return Info;
}

export default function IntroductionView({ sections, hideHeader = false }: IntroductionViewProps) {
  const [openSections, setOpenSections] = useState<Set<string>>(new Set(["0"]));

  const groupedSections = sections.reduce<Record<string, IntroSection[]>>((acc, section) => {
    const key = section.section || "General";
    if (!acc[key]) {
      acc[key] = [];
    }
    acc[key].push(section);
    return acc;
  }, {});

  const toggleSection = (key: string) => {
    const newOpen = new Set(openSections);
    if (newOpen.has(key)) {
      newOpen.delete(key);
    } else {
      newOpen.add(key);
    }
    setOpenSections(newOpen);
  };

  const sectionKeys = Object.keys(groupedSections);

  return (
    <div className="space-y-4">
      {!hideHeader && (
        <div className="mb-6">
          <h2 className="text-2xl font-bold text-foreground mb-2">Training Guide</h2>
          <p className="text-muted-foreground">
            Everything you need to know to follow your training plan effectively.
          </p>
        </div>
      )}

      {sectionKeys.map((sectionName, idx) => {
        const items = groupedSections[sectionName];
        const isOpen = openSections.has(String(idx));
        const Icon = getIconComponent(items[0]?.icon);

        return (
          <Card key={sectionName} className="overflow-hidden">
            <Collapsible open={isOpen} onOpenChange={() => toggleSection(String(idx))}>
              <CollapsibleTrigger asChild>
                <CardHeader
                  className="py-4 px-4 cursor-pointer select-none bg-card"
                  data-testid={`button-section-${idx}`}
                >
                  <div className="flex items-center justify-between gap-3">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-[#FFE100] flex items-center justify-center">
                        <Icon className="w-5 h-5 text-black" />
                      </div>
                      <CardTitle className="text-lg font-semibold">{sectionName}</CardTitle>
                    </div>
                    {isOpen ? (
                      <ChevronDown className="w-5 h-5 text-muted-foreground" />
                    ) : (
                      <ChevronRight className="w-5 h-5 text-muted-foreground" />
                    )}
                  </div>
                </CardHeader>
              </CollapsibleTrigger>
              <CollapsibleContent>
                <CardContent className="pt-0 pb-4 px-4">
                  <div className="space-y-4 pl-13">
                    {items.map((item, itemIdx) => (
                      <div
                        key={item.id}
                        className={cn(
                          "border-l-2 border-[#FFE100] pl-4 py-2",
                          itemIdx === items.length - 1 ? "" : "pb-4"
                        )}
                        data-testid={`section-item-${item.id}`}
                      >
                        {item.type && (
                          <div className="flex items-center gap-2 mb-2">
                            <Badge
                              variant="secondary"
                              className="text-xs font-medium bg-[#FFE100] text-black no-default-hover-elevate no-default-active-elevate"
                            >
                              {item.type}
                            </Badge>
                            {item.hrPercent && (
                              <Badge variant="outline" className="text-xs">
                                HR: {item.hrPercent} from max HR
                              </Badge>
                            )}
                          </div>
                        )}
                        <p className="text-sm text-foreground leading-relaxed">{item.detail}</p>
                        {item.imageUrl && (
                          <div className="mt-3 flex justify-center">
                            <img
                              src={`/exercise-images/${item.imageUrl}.png`}
                              alt={item.type}
                              className="max-w-full h-auto max-h-48 rounded-md"
                              onError={(e) => {
                                e.currentTarget.style.display = 'none';
                              }}
                            />
                          </div>
                        )}
                        {item.videoUrl && (
                          <div className="mt-3 aspect-video rounded-md overflow-hidden bg-muted">
                            <iframe
                              src={item.videoUrl}
                              className="w-full h-full"
                              allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                              allowFullScreen
                              title={item.type}
                            />
                          </div>
                        )}
                      </div>
                    ))}
                  </div>
                </CardContent>
              </CollapsibleContent>
            </Collapsible>
          </Card>
        );
      })}
    </div>
  );
}
